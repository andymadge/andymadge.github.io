# Implementation Plan: Mix Download Link

**Branch**: `002-mix-download-link` | **Date**: 2026-03-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `/specs/002-mix-download-link/spec.md`

## Summary

Add a download anchor link at the end of the mix description on every DJ mix page. The link downloads `audio_url` by default; when the optional `audio_download_url` front matter field is present it takes precedence. Implemented as a single Liquid include added to `_layouts/mix.html` — no JavaScript, no new dependencies.

## Technical Context

**Language/Version**: Ruby 3.x / Jekyll 3.9+ (GitHub Pages gem); Liquid templating; HTML5
**Primary Dependencies**: Jekyll (via `github-pages` gem) — no new dependencies
**Storage**: YAML front matter in `_djmixes/*.md` files (new optional field `audio_download_url`)
**Testing**: Manual — `docker compose up`, then browser verification at `http://localhost:4000`
**Target Platform**: Static site, all modern browsers
**Performance Goals**: N/A — static HTML anchor element, zero runtime cost
**Constraints**: Must remain GitHub Pages-compatible; no server-side code
**Scale/Scope**: One layout change + one new include; affects all mix pages at build time

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Content-First Architecture | ✅ Pass | Change is presentation-only; content stays in Markdown front matter |
| II. Simplicity and Maintainability | ✅ Pass | Single include file + one line in layout; no custom JS |
| III. Static Site Performance | ✅ Pass | Pure static HTML; no server-side processing introduced |
| IV. Backwards Compatibility | ✅ Pass | `audio_download_url` is optional; existing mixes unchanged |
| V. Minimal Dependencies | ✅ Pass | No new gems, plugins, or third-party services |

**Post-design re-check**: No violations. Design uses only existing Liquid/Jekyll primitives.

## Project Structure

### Documentation (this feature)

```text
specs/002-mix-download-link/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks — NOT created here)
```

### Source Code (repository root)

```text
_includes/
└── mix-download.html        # NEW: download link include

_layouts/
└── mix.html                 # MODIFIED: add {% include mix-download.html %} after {{ content }}

_djmixes/
└── *.md                     # OPTIONAL: add audio_download_url field to any mix that needs it
```

**Structure Decision**: Jekyll static site — single project layout. No backend, no build tooling changes. The new include follows the existing pattern (`audio-player.html`, `tracklist.html`, etc.) used throughout `_layouts/mix.html`.
