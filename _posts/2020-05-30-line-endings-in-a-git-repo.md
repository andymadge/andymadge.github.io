---
title: Line Endings in a git Repo
header:
  image: assets/images/header-images/IMG_2053_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - git
toc: true
---
_TL;DR_ If you collaborate with developers on different platforms (Windows/Mac/Linux) and you all use proper programmer's editors which will maintain correct line endings, then the best choice is for everyone to set the `core.autocrlf` git config to `input`.

## Background

Different platforms use different line ending characters, so if you're not careful you can end up with a repo where different files have different endings, or even mixed ending within the same file.

The line ending types are:
<table>
  <tr>
    <td>LF</td>
    <td>Unix, Linux and Mac OS X</td>
  </tr>
  
  <tr>
    <td>CR</td>
    <td>Mac OS up to v9</td>
  </tr>
  
  <tr>
    <td>CR+LF</td>
    <td>Windows</td>
  </tr>
</table>

Mixing line endings in a repo can have various unexpected consequences, one of the most annoying is that when you look at a diff in git, it can show every line of the file as being modified. This makes it hard to see the _real_ modifications for that commit.

Therefore it's important to have consistency in the line endings within a repo.


## Possible Solutions

The git config item [`core.autocrlf`](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration#_core_autocrlf) is used to perform line ending conversions during commit or checkout.

The possible values are:

| Value  | Effect  |
| -----  | ------  |
| `false`  | Don't do any line ending conversion at all. |
| `true`   | Convert line endings to LF during commit, and convert to local system type during checkout. |
| `input`  | Convert line endings to LF during commit, and don't do any conversion during checkout. |

Most people recommend you set this to `true` on Windows.  The problem with this is that people on Windows are not actually seeing the files exactly as they are in the repo.  If your system is in some way susceptible to issues caused by different line endings, those issues become extraordinarily hard to debug, because you're not actually comparing like with like.

Also, any decent developer will be using a proper code editor (VS Code, Atom, Notepad++, Sublime Text etc.) all of which are perfectly capable of reading files with any line ending, and they will also maintain the line endings which already exist in files.  Windows Notepad DOES NOT maintain line ending correctly, but I'm presuming no real developer would be editing code with that!

Therefore there is basically zero benefit to having the line endings as CRLF on Windows, however there is some risk to it. The risk _is_ in narrow edge cases, but that's exactly why it's best to eliminate it; you don't want to waste time debugging such issues.

On the other hand, if you set it to `input` then all files in the repo will be LR, and they will stay that way when checked out by anyone on any platform.

A minor problem with the `input` value is that if you have previously been working on a repo with the wrong setting, there may be files in the repo or your working copy with the wrong line endings.  See "Fixing A Repo" below for how to resolve this issue.


## Setting It

You only need to set this once, it will apply to all git clients and repos.

This can be done from the command line in Windows, Linux or MacOS:

```bash
# check current global value
git config --global core.autocrlf
 
# set to 'input' globally
git config --global core.autocrlf input
```

{% capture note %}
After making the above change, when committing you will often see the message:

```
warning: CRLF will be replaced by LF in <file>
```

**This is expected**; it is precisely what we have told git to do - it is replacing Windows line ending with Unix line endings during commit.
{% endcapture %}

<div class="notice--warning">{{ note | markdownify }}</div>
 
### Repo-specific setting

This can also be set on a per-repo basis if needed (generally not needed if you set globally as above)

```bash
# check current value for current repo
git config core.autocrlf
 
# set to 'input'
git config core.autocrlf input
```

The only difference is the lack of `--global` in the commands.

Alternatively, if you want more fine grained control based on file types, you can commit a file named `.gitattributes` in the repo, with this contents:

```conf
* text=auto eol=lf
*.{cmd,[cC][mM][dD]} text eol=crlf
*.{bat,[bB][aA][tT]} text eol=crlf
```

This will ensure that most files use LF line endings, apart from Windows Batch Files, which will use CRLF. However, it's [not](https://serverfault.com/questions/429594/is-it-safe-to-write-batch-files-with-unix-line-endings/429598#429598) [entirely](https://stackoverflow.com/questions/38836068/lf-versus-crlf-line-endings-in-windows-batch-files) [certain](https://serverfault.com/questions/429594/is-it-safe-to-write-batch-files-with-unix-line-endings/795638#795638) whether CRLF is required for Windows Batch Files.


## Fixing A Repo

If you have previously been working with the wrong autocrlf setting then you will still have files in working copies and repos with the wrong line endings.  This is because the autocrlf setting only takes effect when you commit a file.

You can fix the line endings as follows:

### Fix just a few files in the Repo

```bash
# a single file
git rm --cached -r path/to/file1.py 
git add path/to/file1.py 
 
# multiple files can be included in each line
git rm --cached -r path/to/file2.py path/to/file3.htm
git add path/to/file2.py path/to/file3.htm
 
# Then you need to commit
git commit -m "Fixed crlf issue for some files"
```

### Fix all Files in the repo

See [Stack Exchange](https://stackoverflow.com/questions/1510798/trying-to-fix-line-endings-with-git-filter-branch-but-having-no-luck/1511273#1511273) and [GitHub](https://help.github.com/en/github/using-git/configuring-git-to-handle-line-endings#platform-all)

```bash
# From the root of your repository remove everything from the index
git rm --cached -r .

# Re-add all the deleted files to the index
# (You should get lots of messages like:
#   warning: CRLF will be replaced by LF in <file>.)
git diff --cached --name-only -z | xargs -0 git add

# Commit
git commit -m "Fixed crlf issue"

# If you're doing this on a Unix/MacOS working copy then optionally remove
# the working tree and re-check everything out with the correct line endings.
git ls-files -z | xargs -0 rm
git checkout .
```
