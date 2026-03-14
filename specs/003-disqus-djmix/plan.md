# Implementation Plan: Disqus Comments on DJ Mix Posts

**Branch**: `003-disqus-djmix` | **Date**: 2026-03-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/003-disqus-djmix/spec.md`
**Additional input**: Add a "Comment on this mix" link alongside "Download mix" that scrolls to the Disqus section.

## Summary

Enable Disqus comments on DJ mix pages (currently disabled via `_config.yml` defaults) and add a "Comment on this mix" anchor link in `_includes/mix-download.html` alongside the existing "Download mix" link. Two files change; no new dependencies, plugins, or third-party services required.

## Technical Context

**Language/Version**: Ruby 3.x / Jekyll 3.9+ (via `github-pages` gem); Liquid templates; HTML
**Primary Dependencies**: Minimal Mistakes theme v4.19.3 (remote); Disqus (already configured, shortname: `andymadge`)
**Storage**: N/A
**Testing**: Manual — `bundle exec jekyll serve` locally; production verification post-deploy
**Target Platform**: GitHub Pages (static site)
**Project Type**: Jekyll static site
**Performance Goals**: No measurable impact — purely declarative/template changes
**Constraints**: Must remain GitHub Pages-compatible; no new gems or plugins
**Scale/Scope**: Affects all `_djmixes/` collection pages

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Content-First Architecture | ✅ PASS | Comments enhance content engagement without altering content storage |
| II. Simplicity and Maintainability | ✅ PASS | Two-file change; leverages existing Disqus config already in use for blog posts |
| III. Static Site Performance | ✅ PASS | Disqus loads client-side via JavaScript; no server-side changes |
| IV. Backwards Compatibility | ✅ PASS | No permalink changes; no existing content modified |
| V. Minimal Dependencies | ✅ PASS | No new dependencies; Disqus already approved in constitution |

No violations. Complexity Tracking table not required.

## Project Structure

### Documentation (this feature)

```text
specs/003-disqus-djmix/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── spec.md              # Feature spec
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
_config.yml                      # Change: comments: false → comments: true for _djmixes scope
_includes/mix-download.html      # Change: add "Comment on this mix" anchor link
```

No new files required.

**Structure Decision**: Single-project Jekyll site. Both changes are in-place edits to existing files; no new directories or modules needed.

---

## Phase 0: Research

### Decision Log

#### D-001: How does Minimal Mistakes render Disqus on `single`-layout pages?

**Decision**: Minimal Mistakes' `single` layout automatically includes Disqus when:
1. `site.comments.provider` is set (already `"disqus"` in `_config.yml`)
2. `site.comments.disqus.shortname` is set (already `"andymadge"`)
3. `page.comments` is not `false`

The `mix.html` layout uses `layout: single`, so it inherits this behaviour. The only reason Disqus is absent from mix pages today is the explicit `comments: false` in the `_djmixes` default scope.

**Rationale**: Confirmed by inspecting a built blog post (`_site/2026/03/10/git-hooks-comparison/index.html`) which renders `https://andymadge.disqus.com/embed.js` and `<div id="disqus_thread">`.

**Alternatives considered**: Writing a custom `_includes/disqus_comments.html` — rejected; the theme already handles this correctly.

---

#### D-002: What is the correct scroll target for "Comment on this mix"?

**Decision**: Use `href="#disqus_thread"`. Minimal Mistakes injects `<div id="disqus_thread"></div>` into the page (inherited from the Disqus embed pattern). This is the standard anchor target.

**Rationale**: Native anchor link — zero JavaScript required. Browser handles the smooth-scroll (or instant scroll) natively.

**Alternatives considered**:
- JavaScript `scrollIntoView()` — unnecessary complexity for a standard anchor
- A separate JS smooth-scroll — not needed; browser default is sufficient and aligns with constitution Principle II (simplicity)

---

#### D-003: When should the "Comment on this mix" link be visible?

**Decision**: Show the link when `page.comments != false` (same condition that controls Disqus visibility). In the development environment, the link will appear but clicking it goes nowhere (no `#disqus_thread` element). This is acceptable — the link is visually present but inactive in dev, and fully functional in production.

**Rationale**: Conditional on `jekyll.environment == "production"` would require either a second condition block or duplicating markup. Given the link is harmless in dev (just a non-matching anchor), the simpler approach is preferred per constitution Principle II.

**Alternatives considered**: Hiding the link in development via `jekyll.environment` check — rejected as unnecessary complexity for a dev-only non-issue.

---

#### D-004: Layout of the download/comment links

**Decision**: Place both links inside the existing `<p class="mix-download">` wrapper in `_includes/mix-download.html`. The "Comment on this mix" link renders after "Download mix" (if present) separated by a space. If there is no download URL but comments are enabled, the comment link renders alone in its own paragraph.

**Rationale**: Keeps markup minimal. The existing `mix-download.html` include is the correct location; adding a separate include for a single link would be over-engineering.

**Implementation sketch**:

```liquid
{% assign download_url = page.audio_download_url | default: page.audio_url %}
{% assign show_comment_link = true %}
{% if page.comments == false %}{% assign show_comment_link = false %}{% endif %}

{% if download_url or show_comment_link %}
<p class="mix-download">
  {% if download_url %}<a href="{{ download_url }}" download>Download mix</a>{% endif %}
  {% if show_comment_link %}<a href="#disqus_thread">Comment on this mix</a>{% endif %}
</p>
{% endif %}
```

---

## Phase 1: Design & Contracts

### No API contracts required

This feature has no backend, no API endpoints, and no data model changes. All changes are Liquid template and YAML configuration only.

### Exact changes

#### Change 1: `_config.yml` — enable comments for `_djmixes` scope

**Location**: Line 141 (in `defaults` section, `_djmixes` scope)

**Before**:
```yaml
      comments: false
```

**After**:
```yaml
      comments: true
```

---

#### Change 2: `_includes/mix-download.html` — add "Comment on this mix" link

**Before**:
```liquid
{% assign download_url = page.audio_download_url | default: page.audio_url %}
{% if download_url %}
<p class="mix-download">
  <a href="{{ download_url }}" download>Download mix</a>
</p>
{% endif %}
```

**After**:
```liquid
{% assign download_url = page.audio_download_url | default: page.audio_url %}
{% assign show_comment_link = true %}
{% if page.comments == false %}{% assign show_comment_link = false %}{% endif %}

{% if download_url or show_comment_link %}
<p class="mix-download">
  {% if download_url %}<a href="{{ download_url }}" download>Download mix</a>{% endif %}
  {% if show_comment_link %}<a href="#disqus_thread">Comment on this mix</a>{% endif %}
</p>
{% endif %}
```

---

### Quickstart

See [quickstart.md](quickstart.md).

---

## Post-Design Constitution Check

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Content-First | ✅ PASS | No content structure changes |
| II. Simplicity | ✅ PASS | Two in-place file edits; no new abstractions |
| III. Static Site | ✅ PASS | Pure template/config changes |
| IV. Backwards Compatibility | ✅ PASS | No URLs changed; no existing pages broken |
| V. Minimal Dependencies | ✅ PASS | Zero new dependencies |
