# Research: Mix Download Link

**Branch**: `002-mix-download-link` | **Date**: 2026-03-14

## Summary

No external research was required. All technical decisions follow directly from inspecting the existing codebase and Jekyll/HTML5 standards.

---

## Decision 1: Implementation location

**Decision**: Add a new `_includes/mix-download.html` include, referenced from `_layouts/mix.html` after `{{ content }}` inside `#mix-content`.

**Rationale**: Consistent with the existing pattern — `audio-player.html`, `tracklist.html`, `mix-cover.html`, `mix-image.html` are all separate includes invoked from the layout. Keeps `mix.html` readable and each concern in its own file.

**Alternatives considered**:
- Inline Liquid in `mix.html` directly — rejected: adds noise to an already large layout file.
- Add to the mix Markdown body via a shortcode — not available in Jekyll/Liquid without a plugin.

---

## Decision 2: Download link mechanism

**Decision**: Use an HTML `<a>` element with the `download` attribute pointing to the resolved URL.

**Rationale**: The HTML5 `download` attribute instructs the browser to download the resource rather than navigate to it. This is the standard, dependency-free approach. No JavaScript required.

**Alternatives considered**:
- JavaScript `fetch` + `Blob` — rejected: overkill, breaks without JS, adds complexity.
- Force-download via server header — rejected: not possible on a static GitHub Pages site.

**Cross-origin note**: The `download` attribute only triggers a save dialog for same-origin URLs. For cross-origin URLs (e.g., Dropbox direct links) the browser will still navigate to the resource, but the server's `Content-Disposition` header (already set to `attachment` by Dropbox direct-download links using `dl=1`) ensures the file is downloaded. No workaround needed.

---

## Decision 3: URL priority logic

**Decision**: Use `page.audio_download_url` when present; fall back to `page.audio_url`.

```liquid
{% assign download_url = page.audio_download_url | default: page.audio_url %}
```

**Rationale**: Matches the spec exactly. Liquid's `default` filter provides clean fallback with no conditionals needed for the URL assignment.

**Alternatives considered**:
- Two separate `{% if %}` branches — rejected: more verbose, same result.

---

## Decision 4: Styling

**Decision**: Style using existing site CSS conventions — a plain text link with no additional class beyond what fits the surrounding content area. Exact visual treatment is an implementation detail left to the tasks phase.

**Rationale**: Constitution Principle II (Simplicity). A plain anchor styled by the theme requires zero custom SCSS. A subtle enhancement (e.g., a download icon via CSS `::before`) can be added in the `_sass/music-player.scss` file already used by the audio player, if desired.

---

## No NEEDS CLARIFICATION items

All requirements in the spec were fully specified. No external APIs, no third-party services, no authentication, no data persistence.
