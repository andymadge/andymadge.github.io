# Feature Specification: DJ Mix Hosting

**Feature Branch**: `001-dj-mix-hosting`
**Created**: 2025-11-25
**Status**: Draft
**Input**: User description: "add functionality for hosting music related content. It should appear on the web site under a `/music/` path. For now i just want to host DJ mixes. Each mix needs a dedicated page with a static URL. Requirements are: standard UI component which can be re-used for any hosted mix. Files will be hosted away from the website - normally on Dropbox, but possibly elsewhere in some cases. Must show the cover art, standard audio transport controls. Maybe add a waveform display which is clickable to just to that point. tracklisting. Static text as a minimum, but it would be nice if the current track can be highlighted (that will need to update live)"

## Clarifications

### Session 2025-11-25

- Q: How will mix metadata (title, cover art URL, audio URL, tracklist) be authored and stored? → A: Individual files with YAML front matter (e.g., Jekyll-style content files)
- Q: How will waveform visualizations be generated for the audio files? → A: Client-side generation using JavaScript audio player with pre-generated waveforms as fallback
- Q: Where should persistent playback positions be stored across browser sessions? → A: Browser localStorage (client-side only, per-browser/device)
- Q: What audio file format(s) should the player support? → A: MP3 and AAC/M4A (universal browser support with quality options)
- Q: How should mixes be ordered on the `/music/` index page? → A: Reverse chronological by date (newest first) with future support for user-selectable sort order

## User Scenarios & Testing

### User Story 1 - Listen to a DJ Mix (Priority: P1)

A visitor arrives at the website (on desktop or mobile) wanting to listen to a DJ mix. They navigate to the music section, select a specific mix, and play it using standard audio controls while viewing the cover art and tracklist.

**Why this priority**: This is the core functionality - without this, the feature has no value. It represents the minimum viable product that delivers immediate user value.

**Independent Test**: Can be fully tested by navigating to a mix page URL and playing the audio on both desktop and mobile devices. Delivers standalone value as a functional audio player with metadata.

**Acceptance Scenarios**:

1. **Given** a visitor is on the homepage, **When** they navigate to `/music/`, **Then** they see a list of available DJ mixes
2. **Given** a visitor is viewing the list of mixes, **When** they click on a specific mix, **Then** they are taken to that mix's dedicated page with a static URL
3. **Given** a visitor is on a mix page, **When** the page loads, **Then** they see the mix cover art, audio player with transport controls (play, pause, seek), and the full tracklist (if available)
4. **Given** a visitor is on a mix page, **When** they click play, **Then** the audio begins streaming from the external hosting location (Dropbox or other)
5. **Given** audio is playing, **When** they click pause, **Then** playback stops and can be resumed from the same position
6. **Given** a visitor is on a mobile device, **When** they access a mix page, **Then** the page layout, controls, and audio player are fully functional and properly sized for the mobile screen

---

### User Story 2 - Interactive Waveform Navigation (Priority: P2)

A visitor wants to quickly jump to a specific part of a mix. They see a visual waveform display that represents the audio and can click anywhere on it to jump to that timestamp.

**Why this priority**: This enhances the user experience significantly but isn't essential for basic listening. The core playback functionality remains valuable without it.

**Independent Test**: Can be tested by adding a waveform component to an existing mix page and verifying click-to-seek functionality works independently of other features.

**Acceptance Scenarios**:

1. **Given** a visitor is on a mix page, **When** the page loads, **Then** they see a visual waveform representation of the audio
2. **Given** a visitor sees the waveform, **When** they click on any point in the waveform, **Then** the audio playback jumps to that corresponding timestamp
3. **Given** audio is playing, **When** the playback position changes, **Then** a visual indicator on the waveform shows the current position

---

### User Story 3 - Live Track Highlighting (Priority: P3)

A visitor listening to a mix that has a tracklist can see which track is currently playing, with the tracklist automatically highlighting the active track as playback progresses.

**Why this priority**: This is a nice-to-have enhancement that improves discoverability and engagement but isn't critical for the core listening experience. The static tracklist still provides value without it. This feature only applies when a tracklist with timestamps is provided.

**Independent Test**: Can be tested by implementing track timestamp data and highlighting logic on an existing mix page. Delivers value independently by helping listeners identify current tracks.

**Acceptance Scenarios**:

1. **Given** a visitor is listening to a mix, **When** playback reaches the timestamp of a specific track, **Then** that track is visually highlighted in the tracklist
2. **Given** a track is highlighted, **When** playback moves to the next track, **Then** the highlighting updates to show the new current track
3. **Given** a visitor seeks to a different position in the mix, **When** the playback position lands within a track's timestamp range, **Then** the appropriate track is highlighted immediately

---

### User Story 4 - Persistent Playback Position (Priority: P4)

A visitor starts listening to a mix but needs to leave. When they return to the website hours or days later, they can resume playback from where they left off without manually seeking to find their position.

**Why this priority**: This is a quality-of-life enhancement that significantly improves the user experience for longer mixes, but the core functionality works fine without it. Users can manually seek if needed.

**Independent Test**: Can be tested by playing a mix, pausing partway through, closing the browser, and returning later to verify the position was saved. Delivers value independently by improving user convenience.

**Acceptance Scenarios**:

1. **Given** a visitor is listening to a mix, **When** they pause and close their browser, **Then** the playback position is saved
2. **Given** a visitor returns to a mix page they previously listened to, **When** the page loads, **Then** the audio player shows their last playback position
3. **Given** a saved playback position exists, **When** the visitor clicks play, **Then** playback resumes from the saved position
4. **Given** a visitor has listened to multiple mixes, **When** they return to any mix, **Then** each mix remembers its own independent playback position

---

### Edge Cases

- What happens when the externally hosted audio file is unavailable or returns an error?
- What happens if an unsupported audio format is provided (not MP3 or AAC/M4A)? System should display clear error message.
- How does the system handle extremely long mixes (e.g., 3+ hours)?
- What happens if a mix has no tracklist data provided? (The audio player should still function fully, just without the tracklist display)
- How does the waveform display render on mobile devices with limited screen width?
- What happens if track timestamps overlap or are missing for some tracks?
- How does the player handle slow network connections or buffering?
- Can a tracklist be added or updated after a mix page is initially published?
- What happens if client-side waveform generation fails (browser incompatibility, large file size, etc.)? System should fall back to pre-generated waveform or display without waveform.
- How does touch interaction work on mobile devices (tap to play/pause, swipe for seek, pinch for waveform)?
- What happens if a user clears their browser data (localStorage) and loses their saved playback positions? System should gracefully handle missing data and start from beginning.
- How long should playback positions be stored in localStorage (indefinitely, or expire after a certain time)?
- What happens if localStorage is disabled or unavailable? System should function normally without position persistence.
- How does the system handle mobile browsers that may restrict autoplay or background audio?

## Requirements

### Functional Requirements

- **FR-001**: System MUST provide a `/music/` path that displays all available DJ mixes by aggregating individual mix content files, sorted in reverse chronological order by date (newest first)
- **FR-002**: System MUST generate a unique, static URL for each individual DJ mix (e.g., `/music/mix-name/`)
- **FR-003**: Each mix MUST be stored as an individual content file with YAML front matter containing all metadata (title, audio URL, cover art URL, tracklist, etc.)
- **FR-004**: Each mix page MUST display cover art prominently
- **FR-005**: Each mix page MUST include an audio player with standard transport controls (play, pause, seek/scrub, volume control)
- **FR-006**: System MUST support streaming audio files in MP3 and AAC/M4A formats hosted on external services (Dropbox and potentially others)
- **FR-007**: Each mix page SHOULD display a tracklist showing all tracks in the mix when tracklist data is available
- **FR-008**: When provided, tracklist data MUST follow the format: `[HH:MM:SS] Artist Name - Track Title` with optional metadata in brackets
- **FR-009**: System MUST provide a reusable audio player component that can be used for any mix
- **FR-010**: System MUST be fully functional on mobile devices (responsive design, touch controls)
- **FR-011**: Audio player MUST maintain playback state within a session (e.g., resume from same position after pause)
- **FR-012**: System SHOULD persist playback position across sessions using browser localStorage so users can return later and resume from where they left off (per-browser/device)
- **FR-013**: System SHOULD display a visual waveform representation of the audio using pre-generated waveform data. Fallback to simple progress bar if waveform data unavailable. (Note: Client-side generation is future enhancement, not in current scope)
- **FR-014**: Waveform SHOULD be interactive, allowing users to click to jump to specific timestamps
- **FR-015**: Mix pages MUST function fully (audio playback, controls, cover art) even when no tracklist data is provided
- **FR-016**: System SHOULD support automatic track highlighting that updates as playback progresses when tracklist timestamp data is available
- **FR-017**: Track highlighting SHOULD respond to manual seeking by immediately updating to the correct track
- **FR-018**: System MUST handle audio loading errors gracefully with user-friendly error messages

### Out of Scope (Future Enhancements)

- User-selectable sort order on mix index page (alphabetical, manual ordering, etc.)
- Advanced filtering or search capabilities on mix index
- Social sharing features
- Disqus comments integration on mix pages (consistent with existing blog commenting system)
- Download functionality

### Key Entities

- **DJ Mix**: Represents a complete mix recording stored as an individual content file with YAML front matter containing metadata (title, cover art image URL, external audio file URL, publication date, optional description, optional tracklist, and optional pre-generated waveform data). Each mix file generates its own page with a static URL.
- **Track**: Represents an individual track within a mix, including artist name, track title, and timestamp position. Format: `[HH:MM:SS] Artist Name - Track Title` with optional metadata (e.g., `[00:08:41] Invisible Inc - Stars [Ambient Version]`). Tracks are optional and can be added after initial publication.
- **Mix Page**: A dedicated web page for each mix that combines the audio player component, cover art, and tracklist display (when available)
- **Mix Index**: An automatically generated listing page at `/music/` that aggregates all mix content files and displays them as a browsable list

## Success Criteria

### Measurable Outcomes

- **SC-001**: Visitors can load a mix page and begin playback within 5 seconds on standard broadband connections
- **SC-002**: Audio player controls respond to user interactions (play, pause, seek) within 100 milliseconds
- **SC-003**: Each mix has a permanent, bookmarkable URL that remains accessible over time
- **SC-004**: The audio player component can be reused for any mix without code modifications (only data/content changes required)
- **SC-005**: Mix pages render correctly and remain fully functional on mobile devices with screens as small as 320px wide
- **SC-006**: Touch controls on mobile devices (tap, swipe, pinch) work as intuitively as mouse interactions on desktop
- **SC-007**: Waveform visualization (if implemented) renders accurately across desktop and mobile viewports
- **SC-008**: Track highlighting (if implemented) updates within 500 milliseconds of playback position change
- **SC-009**: Playback position persistence (if implemented) saves and restores position with 95% reliability across browser sessions
- **SC-010**: System gracefully handles audio loading failures with clear feedback to the user rather than silent failure
