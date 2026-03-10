# Implementation Plan: DJ Mix Hosting

**Branch**: `001-dj-mix-hosting` | **Date**: 2026-02-21 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-dj-mix-hosting/spec.md`

## Summary

Adds a `/music/` section to andymadge.github.io hosting DJ mixes as a Jekyll collection. Each mix has a static page combining an HTML5 audio player (WaveSurfer.js v7), pre-generated waveform visualization, cover art, and an optional tracklist with live track highlighting and localStorage-backed playback persistence. Authoring tooling (shell scripts) automates mix file creation, waveform generation, and Dropbox URL normalization.

The core feature (P1–P4 user stories, FR-001–FR-027) is predominantly built. Outstanding work is confined to: mix index UI polish (FR-028–033), audio loading state feedback (FR-005 clarification), a minor spec/code discrepancy in the localStorage TTL policy, and WaveSurfer.js CDN version pinning.

## Technical Context

**Language/Version**: Ruby / Jekyll 3.9+ (GitHub Pages gem), JavaScript ES6+, Liquid templates, SCSS
**Primary Dependencies**: WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, optional dev-time), HTML5 Audio API (browser-native)
**Storage**: Jekyll collection files (`_djmixes/*.md` YAML front matter), browser localStorage (playback positions, LRU cap 20 mixes), filesystem binary assets (`assets/djmixes/{slug}/waveform.dat`)
**Testing**: `bundle exec jekyll serve` local preview; manual browser testing; no automated test suite
**Target Platform**: GitHub Pages (static hosting), desktop + mobile browsers with ES6+ support
**Project Type**: Single static Jekyll project (no backend, no build pipeline beyond `bundle exec jekyll build`)
**Performance Goals**: Mix page load → playback ready ≤5s on standard broadband; UI interaction response ≤100ms; track highlight update ≤500ms
**Constraints**: GitHub Pages-compatible only; all JS runs client-side; no npm/bundler (plain `<script>` tags); Jekyll 3.9 Liquid templates; BSD-compatible shell scripts (macOS)
**Scale/Scope**: Small personal collection (<50 mixes); single-author; no user accounts

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Content-First | ✅ PASS | Mix content stored as Markdown files with YAML front matter in `_djmixes/`; remains accessible independent of any tooling |
| II. Simplicity | ✅ PASS | WaveSurfer.js justified: waveform visualisation not achievable with HTML5 audio alone; 3 focused JS modules with clear separation of concerns; no framework overhead |
| III. Static Site | ✅ PASS | Pure Jekyll static output; audio served from external hosting (Dropbox); no server-side code |
| IV. Backwards Compatibility | ✅ PASS | New `/music/` permalink namespace only; existing blog post URLs and `_config.yml` permalink format unchanged |
| V. Minimal Dependencies | ⚠️ JUSTIFIED | WaveSurfer.js v7 pinned with `@7` (minor version float — **ACTION REQUIRED**: pin to exact semver e.g. `@7.8.x`); `audiowaveform` and `ffprobe` are dev-time tools only, not runtime site dependencies |

**Post-Phase 1 re-check**: No new dependencies introduced in design. WaveSurfer CDN version pinning is a task-level action item.

## Project Structure

### Documentation (this feature)

```text
specs/001-dj-mix-hosting/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/
│   ├── front-matter-schema.md   # Phase 1 output
│   └── js-module-api.md         # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks — not created here)
```

### Source Code (repository root)

```text
_djmixes/                        # Jekyll collection: one .md file per mix
│   └── YYYY-MM-DD-{slug}.md

_layouts/
│   ├── mix.html                 # Individual mix page layout
│   └── mix-index.html           # /music/ index layout

_includes/
│   ├── audio-player.html        # Audio player HTML shell + script init
│   ├── wavesurfer-loader.html   # WaveSurfer.js CDN <script> tag
│   ├── tracklist.html           # Tracklist component (click-to-seek)
│   ├── mix-cover.html           # Cover art display
│   └── mix-image.html           # Optional mix image (opens in new tab)

_sass/
│   └── music-player.scss        # All DJ mix SCSS (439 lines)

_pages/
│   └── music.md                 # /music/ index (layout: mix-index)

assets/
│   ├── css/main.scss            # Imports music-player.scss
│   ├── js/
│   │   ├── audio-player.js          # WaveSurfer.js wrapper (318 lines)
│   │   ├── track-highlighter.js     # Live tracklist highlighting (178 lines)
│   │   └── playback-persistence.js  # localStorage position saving (285 lines)
│   └── djmixes/
│       ├── common/default-cover.svg # Fallback cover art
│       └── {mix-slug}/
│           ├── waveform.dat     # Pre-generated binary (audiowaveform -b 8 -z 256)
│           ├── cover.png        # Cover art (optional)
│           └── *.png            # Optional mix images

scripts/
│   ├── add-mix.sh               # Create mix file + generate waveform
│   └── generate-waveforms.sh   # Batch waveform (re)generation

_config.yml                      # djmixes collection + layout defaults
Gemfile / Gemfile.lock           # github-pages gem, pinned versions
```

**Structure Decision**: Single Jekyll project. No backend. No build pipeline beyond `bundle exec jekyll build`. JavaScript modules are plain ES6 classes loaded with `<script>` tags — no bundler, consistent with GitHub Pages static constraints.

## Complexity Tracking

No violations requiring justification beyond the WaveSurfer.js CDN pinning note above (minor version float is a risk, not a current violation). No repository pattern, no extra projects, no dynamic infrastructure.

## Outstanding Items at Plan Time

The following requirements are identified as not yet fully implemented and will drive task generation:

| Requirement | Description | Gap |
|-------------|-------------|-----|
| FR-005 (clarified) | Loading spinner on play button; controls disabled until ready | Loading state UI not confirmed in audio-player.js |
| FR-012 (clarified) | Indefinite localStorage storage (no TTL) | `playback-persistence.js` has 90-day TTL — contradicts spec |
| FR-028 | Mix grid min card width ~180px | Current min-width is 280px in `.mix-grid` |
| FR-029 | No text underlines on `.mix-card` elements | Not confirmed in music-player.scss |
| FR-030 | No emoji in metadata labels | Not confirmed in mix-index.html template |
| FR-031 | Date displayed as `YYYY/MM/DD` | Not confirmed in mix-index.html |
| FR-032 | Duration omitted from mix cards | mix-index.html shows duration field |
| FR-033 | `mix_image_caption` inherits body font size | Not confirmed in music-player.scss |
| Dependency | WaveSurfer.js CDN pinned at `@7` (minor float) | Pin to exact version in wavesurfer-loader.html |
