---
title: Git Hook Frameworks Comparison
excerpt: A comparison of approaches to sharing git hooks across a team, including the hand-written approach, Husky, pre-commit, and Lefthook.
header:
  image: assets/images/header-images/IMG_4634_w2500.jpeg
categories:
  - Computers
  - Software Engineering
tags:
  - git
toc: true
---
# Sharing Git Hooks Across a Team

Git hooks are shell scripts placed in `.git/hooks/` that git executes automatically on certain events - before a commit is finalised, before a push, after a checkout, and so on. They're commonly used to perform tasks like running a linter, validating commit message format, or blocking a push to a protected branch. These are exactly the things you want applied consistently across every developer on a project (or even just across your own computers) but the problem is that `.git/hooks/` is not committed to the repo - so by default, every developer starts with nothing and is expected to wire it all up themselves.

There are various ways to approach this issue, some of the common ones are:

- The hand-written `core.hooksPath` approach
- [Husky](https://typicode.github.io/husky/)
- [pre-commit](https://pre-commit.com/)
- [Lefthook](https://lefthook.dev/)

They differ enough that the right choice depends on the project. We'll describe each approach, then discuss which to use in different scenarios, and finally cover some security considerations.

If you just want the TL;DR, skip to the [Which to use](#which-to-use) section below, but also ensure you read the [Security considerations](#security-considerations) section at the end - it's important regardless of which approach you choose.


## The hand-written approach

Git natively supports pointing its hooks directory at any path via `core.hooksPath`:

```bash
git config core.hooksPath .githooks
```

You commit your hooks to `.githooks/` in the repo as plain shell scripts. Any developer who runs that one command gets them wired up. No tooling, no dependencies, nothing added to the repo's dependency model.

The weakness is that `git config core.hooksPath .githooks` is not automatic - developers must run it after cloning. This is typically solved with a bootstrap script in the repo:

```bash
# scripts/setup-githooks.sh
git config core.hooksPath .githooks
```

Document it in the README and the friction largely disappears.

NOTE: The hook scripts must be named correctly to be recognised by git - the names must match the sample files in `.git/hooks/` (e.g. `pre-commit`, `commit-msg`, `pre-push` etc.). They must also have the executable bit set (`chmod +x`). This applies to all four approaches covered here, but it's most likely to catch you out when writing hooks by hand.

For projects with simple hook requirements this approach is genuinely underrated. The hooks are transparent shell scripts, there's nothing to install, and there's nothing to explain to a developer unfamiliar with the tooling. The downside is that you're writing and maintaining everything yourself - there's no ecosystem of pre-built checks to draw from.

### Windows Compatibility

For this approach (and Husky below) the hooks are 100% standard git hooks (i.e. POSIX shell scripts), they are just moved to a different location. On Windows, Git for Windows bundles its own POSIX-compatible shell (`sh.exe`). When Git invokes a hook it always uses this bundled shell, regardless of which terminal (`cmd`, PowerShell, Git Bash, etc.) was used to run `git commit`. This means that the hooks will run correctly on Windows without any special handling, as long as they are valid POSIX shell scripts.

Of course, you still need to ensure that any tools invoked by the hooks (e.g. linters, formatters) are installed and available in the PATH on all platforms, but the hook scripts themselves are Windows compatible as long as they are valid shell scripts.

## Husky

[Husky](https://typicode.github.io/husky/) installs as an npm devDependency and sets `core.hooksPath` to `.husky/`. Hooks are shell scripts in that directory. Because it's wired up via npm's `prepare` script, running `npm install` is all a developer needs to do after cloning - no manual setup step.

```bash
npm install --save-dev husky
npx husky init
```

It's extremely lightweight (~2kB, no dependencies), fast, and transparent - you can read exactly what each hook does. It pairs naturally with [lint-staged](https://github.com/lint-staged/lint-staged) and [commitlint](https://commitlint.js.org/), which cover most common use cases out of the box.

Husky has no hook registry so you need to write each hook manually. There is also no environment isolation - hooks run against whatever is available in `node_modules` or on `PATH`. Framework and tool version drift between developers is your problem to manage.

See [https://github.com/andymadge/husky-node](https://github.com/andymadge/husky-node) for a sample repo which uses Husky. It includes a very basic Node application and 3 hooks - `pre-commit`, `commit-msg` and `post-commit`. The scripts are described in the README along with instructions for setting up in a different repo.

`NOTE:` Husky is only practical if the repo already has a `package.json`. Adding one purely to get git hooks contaminates a non-JS project with npm infrastructure - `node_modules` in a Java repo, `package.json` for CI systems to trip over, and confusion for anyone new to the codebase. The fact that full-stack developers will have Node installed doesn't change this.

## pre-commit

[pre-commit](https://pre-commit.com/) is a Python-based hook manager with its own package registry. Hooks are declared in `.pre-commit-config.yaml` with pinned revisions:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
  - repo: https://github.com/psf/black
    rev: 25.1.0
    hooks:
      - id: black
```

The configured hooks are checked on each run, and if they're not present, pre-commit automatically clones the specified repo and checks out the pinned revision. This means that the hooks are always consistent across developers without any manual setup beyond installing pre-commit itself.

Despite the name, pre-commit supports all hook types, not just `pre-commit`, through the use of the `stage` field [in the config](https://pre-commit.com/#confining-hooks-to-run-at-certain-stages). Each hook will specify which stage(s) it should run at, but you can pass the [`stage`](https://pre-commit.com/#config-stages) field to override it if needed.

pre-commit manages isolated environments for each hook. If a hook needs Ruby or Node and neither is installed, pre-commit bootstraps them automatically. It can even run hooks inside Docker containers if required. This is what makes it practical in polyglot or non-JS repos - you can run an eslint hook on a Python project without adding any JS infrastructure to the repo itself.

Developers install the manager once globally:

```bash
pip install pre-commit
```

Then run once per repo clone:

```bash
pre-commit install
```

The config is committed, hook versions are pinned, and `pre-commit autoupdate` keeps them current.

The trade-offs: Python is required to install the manager (even if your project doesn't use it), first-run is slow while hook environments are built, and the abstraction layer can make debugging harder than with a plain shell script.

## Lefthook

[Lefthook](https://lefthook.dev/) is a Go-based hook manager distributed as a single binary with no runtime dependency. Hooks are declared in `lefthook.yml`:

```yaml
pre-commit:
  commands:
    lint:
      run: npx eslint {staged_files}
    format:
      run: black {staged_files}
```

Because it's a single binary, installation is straightforward — via Homebrew, npm, a package manager, or just downloading the binary directly. It supports parallel hook execution, which makes it noticeably faster than pre-commit on larger hook sets. Like Husky, hooks can be written for any tool available on PATH, but unlike Husky it's not tied to Node and doesn't require a `package.json`.

It hasn't reached the adoption level of pre-commit or Husky, so the ecosystem of community hooks is smaller, and you're more likely to be writing configuration from scratch. But for teams that want something more structured than the hand-written approach, more capable than Husky, and lighter than pre-commit, it's worth serious consideration.


## Which to use

The decision mostly hinges on one question: does the repo already have a `package.json`?

**Repo has a `package.json`** - Husky is a legitimate choice. Setup is automatic, the hooks are transparent, and it integrates naturally with the JS ecosystem tooling you're probably already using. pre-commit is also valid if you want environment isolation or a richer set of pre-built checks.

**Repo has no `package.json`** - pre-commit, Lefthook, or the hand-written approach. Don't add npm infrastructure to a non-JS project to get git hooks.

Between the three for non-JS repos: 

  - If your hook needs are simple (run the test suite, check formatting with a tool already in PATH), the hand-written approach is clean and requires no explanation. 
  - If you want parallel execution, a structured config, and no runtime dependency, Lefthook is a strong option. 
  - If you want the broadest ecosystem of pre-built checks and full environment isolation — including the ability to run hooks in languages not installed on the developer's machine — pre-commit is the better fit.

## Security considerations

NOTE: Git hooks can be bypassed entirely with `git commit --no-verify`. Since it's trivial for any developer to skip hooks in their local repo, they should never be relied upon to enforce anything. Such enforcements belong in CI where they can't be skipped. It's worth being aware of this regardless of which approach you use - hooks are a useful tool for developer convenience and consistency, but they are not a security boundary.

Aside from that, the most significant concern is the supply chain risks associated with each approach:

**Hand-written** - the lowest risk. There are no external dependencies to compromise. Hook scripts are committed to the repo and reviewed like any other code change. The only realistic attack vector is a malicious contributor with commit access modifying a hook script directly.

**Husky** - Husky is an npm package and is subject to the same supply chain risks as any other: a compromised package version, a typosquatting attack, or a maintainer account takeover. The fact that it has no dependencies of its own reduces the attack surface, but doesn't eliminate the risk from the package itself. The `prepare` script makes this slightly more acute - a compromised version of Husky would execute automatically on `npm install` without any explicit developer action.

**Lefthook** - similar risk profile to Husky. Whether installed via Homebrew, npm, or as a direct binary download, you're trusting a third-party package and any of those distribution channels could in principle be compromised. The binary distribution angle is worth noting because a compromised binary is harder to audit than JavaScript source, but the overall risk level is comparable.

**pre-commit** - subject to the same package-level risks as the others, but the attack surface is larger because each hook is also pulled from an external git repo. If a hook repo is compromised and a tag is moved to point at a malicious commit, you'd pull it on the next `pre-commit autoupdate`. Using the `--freeze` flag mitigates this by storing immutable SHA hashes instead of tag names, which is worth doing in any serious project.
