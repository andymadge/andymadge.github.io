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
- JavaScript audio player library (NEEDS CLARIFICATION: specific library selection)
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
- **Status**: NEEDS VERIFICATION (Phase 1)
- **Rationale**: Will add JavaScript audio player library. Must verify: (1) No Jekyll plugin dependencies required beyond existing, (2) JavaScript library selection justified by features needed (waveform, localStorage integration).

### Summary
- **Gate Status**: CONDITIONAL PASS - proceed to Phase 0 research
- **Re-evaluation Required**: After JavaScript library selection in Phase 1
- **Risk**: Low - feature aligns well with constitutional principles

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

**Status**: PENDING

### Research Tasks

1. **JavaScript Audio Player Library Selection**
   - **Unknown**: Which library best supports requirements (waveform, HTML5 audio, localStorage integration)?
   - **Research Focus**:
     - Evaluate: WaveSurfer.js, Plyr, Amplitude.js, Howler.js
     - Criteria: Waveform support, mobile compatibility, file size, documentation quality
     - Decision: Select library and document rationale

2. **Waveform Generation Best Practices**
   - **Unknown**: Client-side generation performance for large files? Pre-generation workflow?
   - **Research Focus**:
     - Client-side generation limitations (file size, browser compatibility)
     - Pre-generation tools and formats (peaks.js, audiowaveform)
     - Fallback strategy implementation

3. **External Audio Hosting (Dropbox)**
   - **Unknown**: Direct streaming URLs? CORS configuration? Reliability?
   - **Research Focus**:
     - Dropbox direct link format (dl=1 parameter)
     - CORS headers and browser compatibility
     - Alternative hosting options (if Dropbox insufficient)

4. **Jekyll Collections Configuration**
   - **Unknown**: Optimal collection setup for mix content?
   - **Research Focus**:
     - Collections vs. pages for mix content
     - Permalink structure for `/music/mix-name/`
     - Front matter schema design

5. **localStorage Best Practices**
   - **Unknown**: Key naming, data structure, expiration strategy?
   - **Research Focus**:
     - localStorage API patterns for media playback
     - Data structure for multiple mix positions
     - Graceful degradation when unavailable

**Output**: research.md with decisions documented

---

## Phase 1: Design & Contracts

**Status**: PENDING (awaits Phase 0 completion)

### Deliverables

1. **data-model.md**: Document YAML front matter schema for mix files
2. **contracts/**: Define JavaScript module interfaces (audio player API, localStorage schema)
3. **quickstart.md**: Instructions for adding a new mix, local testing, deployment
4. **Agent context update**: Run `.specify/scripts/bash/update-agent-context.sh claude`

### Design Outputs Expected

- YAML front matter schema with all required/optional fields
- JavaScript module API contracts (initialization, events, storage format)
- HTML structure for audio player component
- CSS class naming conventions
- Responsive breakpoint strategy

---

## Phase 2: Task Breakdown

**Status**: NOT STARTED (handled by `/speckit.tasks` command)

This phase is executed by a separate command after Phase 0-1 complete.
