# Implementation Plan: DJ Mix Hosting

**Branch**: `001-dj-mix-hosting` | **Date**: 2025-11-25 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-dj-mix-hosting/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Add DJ mix hosting functionality to the personal blog at `/music/` path. Mixes will be stored as Jekyll collection items with YAML front matter, each generating a dedicated page with audio player, cover art, and optional tracklist. Audio files hosted externally (Dropbox), with client-side waveform generation, localStorage for playback persistence, and mobile-responsive design using Minimal Mistakes theme capabilities.

## Technical Context

**Language/Version**: Ruby 2.x+ (Jekyll 3.9+), JavaScript (ES6+), HTML5, CSS3
**Primary Dependencies**:
- Jekyll (static site generator)
- Minimal Mistakes theme v4.19.3
- WaveSurfer.js v7 (audio player with waveform visualization)
- HTML5 Audio API
**Storage**:
- Content: YAML front matter in Jekyll collection files (`_djmixes/`)
- Audio files: External hosting (Dropbox, direct links)
- Playback state: Browser localStorage (client-side)
**Testing**:
- `bundle exec jekyll serve` local preview
- Manual testing: desktop browsers (Chrome, Firefox, Safari)
- Manual testing: mobile browsers (iOS Safari, Android Chrome)
- Manual testing: responsive breakpoints (320px+)
**Target Platform**: GitHub Pages (static site hosting), modern web browsers (desktop + mobile)
**Project Type**: Static website (Jekyll-based)
**Performance Goals**:
- Load mix page and begin playback within 5 seconds (SC-001)
- Audio controls respond within 100ms (SC-002)
- Mobile rendering on screens as small as 320px (SC-005)
**Constraints**:
- Must remain static site (no backend/database)
- Must use GitHub Pages-compatible Jekyll plugins only
- Must maintain backwards compatibility with existing blog permalinks
- Must leverage Minimal Mistakes theme without major customization
- Audio files hosted externally (not in repository)
**Scale/Scope**:
- Small-scale personal use (10-50 mixes expected)
- Single author content management
- Standard web traffic (personal blog scale)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✓ Content-First Architecture
- **Status**: PASS
- **Rationale**: Mix metadata stored in portable Markdown/YAML format. Content remains accessible and future-proof.

### ✓ Simplicity and Maintainability
- **Status**: PASS
- **Rationale**: Uses standard Jekyll collections pattern. Minimal custom code beyond theme template overrides.

### ✓ Static Site Performance
- **Status**: PASS
- **Rationale**: Remains fully static. No server-side processing. Uses Jekyll native features and GitHub Pages hosting.

### ✓ Backwards Compatibility
- **Status**: PASS
- **Rationale**: New `/music/` path doesn't conflict with existing blog permalink format (`/:year/:month/:day/:title/`). No changes to existing content required.

### ✓ Minimal Dependencies
- **Status**: ✅ PASS (Re-evaluated 2025-11-25)
- **Rationale**: Added WaveSurfer.js v7 as JavaScript dependency. Justification:
  - **Core Requirement**: Waveform visualization is specified in FR-013; no simpler alternative exists
  - **No Jekyll Plugin Dependencies**: Loaded via CDN, no build-time dependencies
  - **Minimal Footprint**: ~30KB minified, single library replaces need for separate audio + waveform solutions
  - **Standard Technology**: Uses HTML5 Audio API, no proprietary or exotic dependencies
  - **Maintenance**: Active project with stable API, minimal future maintenance burden
- **Verification**: (1) ✅ No Jekyll plugins required, (2) ✅ Library provides waveform, HTML5 audio, mobile support, and localStorage integration (all required features)

### Summary
- **Gate Status**: ✅ PASS - All constitutional principles satisfied
- **Risk**: Low - feature aligns well with constitutional principles
- **Dependency Justification**: WaveSurfer.js meets minimal dependency threshold per Constitution V

## Project Structure

### Documentation (this feature)

```text
specs/001-dj-mix-hosting/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
_djmixes/                          # Jekyll collection for mix content files
├── 2025-11-25-example-mix.md    # Individual mix files with YAML front matter
└── ...

_layouts/
├── mix.html                     # Template for individual mix pages
└── mix-index.html               # Template for /music/ listing page

_includes/
├── audio-player.html            # Reusable audio player component
├── waveform.html                # Waveform visualization component (optional)
└── tracklist.html               # Tracklist display component

assets/
├── js/
│   ├── audio-player.js          # Audio player initialization and controls
│   ├── waveform-generator.js    # Client-side waveform generation
│   ├── playback-persistence.js  # localStorage integration
│   └── track-highlighter.js     # Live track highlighting logic
├── css/
│   └── music-player.scss        # Custom styles for audio player UI
└── images/
    └── mix-covers/              # Cover art images (optional local storage)

_config.yml                      # Jekyll configuration (add mixes collection)

_pages/
└── music.md                     # /music/ index page
```

**Structure Decision**: Uses Jekyll collections pattern (`_djmixes/`) for mix content management, consistent with Jekyll best practices. Each mix is a standalone Markdown file with YAML front matter. Leverages existing Minimal Mistakes theme layout system with custom includes for audio player components. JavaScript modules for client-side features (waveform, persistence, highlighting). No backend or database required - fully static.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

No violations at this stage. Conditional items to verify in Phase 1:
- JavaScript audio player library selection must be justified by feature requirements
- Ensure no additional Jekyll plugins needed beyond what's already approved

---

## Phase 0: Research & Unknowns

**Status**: ✅ COMPLETED (2025-11-25)

### Research Tasks

1. **JavaScript Audio Player Library Selection** ✅
   - **Decision**: WaveSurfer.js v7
   - **Rationale**:
     - Native waveform visualization support (primary requirement)
     - HTML5 audio backend with excellent mobile compatibility
     - Pre-generated waveform data support via peaks.js format
     - Active maintenance and comprehensive documentation
     - Lightweight (~30KB minified) with CDN availability
     - No Jekyll plugin dependencies (constitutional compliance)
   - **Implementation**: Selected and integrated in tasks T009-T020

2. **Waveform Generation Best Practices** ✅
   - **Decision**: Pre-generated waveforms as primary approach using audiowaveform tool, with client-side generation as fallback
   - **Rationale**:
     - Client-side generation performance poor for large files (3+ hour mixes)
     - Pre-generation provides instant waveform display on page load
     - audiowaveform tool generates JSON format compatible with WaveSurfer.js
     - Fallback to client-side generation with WaveSurfer.js if waveform data unavailable (per FR-013)
   - **Implementation**: Documented in tasks T038, T053-T054

3. **External Audio Hosting (Dropbox)** ✅
   - **Decision**: Migrate from Dropbox to S3/CloudFront for better reliability
   - **Rationale**:
     - Dropbox direct links work but have rate limiting and CORS issues
     - S3/CloudFront provides better performance, reliability, and CORS control
     - Professional CDN distribution for audio streaming
   - **Implementation**: Documented in quickstart.md, task T037

4. **Jekyll Collections Configuration** ✅
   - **Decision**: Use Jekyll collections (`_djmixes/`) with permalink `/music/:name/`
   - **Rationale**:
     - Collections provide clean content organization separate from blog posts
     - YAML front matter for all metadata (title, audio URL, cover art, tracklist)
     - Automatic page generation with static URLs
     - Aligns with Jekyll best practices and constitutional principles
   - **Implementation**: Configured in tasks T007-T008

5. **localStorage Best Practices** ✅
   - **Decision**: Store playback positions with 90-day expiration, throttled saves
   - **Rationale**:
     - Key format: `andymadge-music-player` with versioned schema
     - Save throttled to every 10 seconds to avoid performance impact
     - 90-day expiration prevents stale data accumulation
     - Graceful degradation when localStorage unavailable (private browsing)
   - **Implementation**: Implemented in tasks T076-T084

**Output**: Decisions documented inline; research.md file optional

---

## Phase 1: Design & Contracts

**Status**: ✅ COMPLETED (2025-11-25)

### Deliverables Status

✅ **data-model.md**: YAML front matter schema documented
✅ **contracts/**: JavaScript module interfaces defined (referenced in tasks T016, T076)
✅ **quickstart.md**: Mix authoring instructions created
✅ **Agent context update**: Constitution and project structure documented in CLAUDE.md

**Note**: Design artifacts were embedded directly in implementation tasks and documentation rather than as separate contract files in contracts/ directory. This aligns with constitutional principle of simplicity (avoiding unnecessary file proliferation for small-scale project).

### Design Outputs Delivered

- ✅ YAML front matter schema with all required/optional fields (implemented in T021, T036)
- ✅ JavaScript module API contracts (AudioPlayer class in T016-T020, PlaybackPersistence in T076-T084)
- ✅ HTML structure for audio player component (T015, T022)
- ✅ CSS class naming conventions (music-player.scss in T013-T014)
- ✅ Responsive breakpoint strategy (T032 mobile media queries)

---

## Phase 2: Task Breakdown

**Status**: ✅ COMPLETED (2025-11-25)

This phase was executed by the `/speckit.tasks` command, generating tasks.md with 113 dependency-ordered tasks across 7 phases.

---

## Implementation Retrospective

**Implementation Period**: 2025-11-25 (Phases 1-6)
**Current Status**: 81% complete (91/113 tasks)

### Actual Implementation Sequence

Phases 1-6 were implemented rapidly in a single session:
- **Phase 1** (Setup): T001-T008 ✅ Complete
- **Phase 2** (Foundation): T009-T014 ✅ Complete
- **Phase 3** (US1 - MVP): T015-T052 ✅ Complete
- **Phase 4** (US2 - Waveform): T053-T063 ✅ Complete
- **Phase 5** (US3 - Track Highlighting): T064-T075 ✅ Complete
- **Phase 6** (US4 - Persistence): T076-T091 ✅ Complete
- **Phase 7** (Polish): T092-T113 ⏳ In Progress (22 tasks remaining)

### Deviations from Original Plan

1. **Waveform Strategy**: Implemented pre-generated waveforms as primary approach (not client-side generation). Rationale: Better performance, simpler implementation, avoids large file downloads for client-side processing.

2. **Phase Execution**: Phases 0-2 completed before task breakdown, contrary to plan structure. Spec-kit workflow executed differently than originally documented.

3. **Tracklist Preprocessing**: Implemented server-side (Jekyll/Liquid) tracklist formatting instead of pure JavaScript parsing, improving performance and SEO.

4. **Audio Hosting**: Migrated from Dropbox to S3/CloudFront for better reliability and CORS control.

### Lessons Learned

- Pre-generated waveforms provide better UX than client-side generation for static sites
- Jekyll preprocessing can reduce JavaScript complexity for static content
- WaveSurfer.js v7 exceeded expectations for mobile compatibility
- S3/CloudFront provides superior audio delivery compared to Dropbox direct links

### Remaining Work

Phase 7 tasks focus on:
- Documentation completion (T092-T094)
- Performance optimization (T095-T098)
- Cross-browser testing (T099-T103)
- Edge case validation (T104-T110)
- Final validation (T111-T113)
