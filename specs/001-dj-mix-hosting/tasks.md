# Implementation Tasks: DJ Mix Hosting

**Branch**: `001-dj-mix-hosting` | **Date**: 2025-11-25 | **Spec**: [spec.md](./spec.md)

This file breaks down the implementation into dependency-ordered tasks. Each task follows the format: `- [ ] [TaskID] [P?] [Story?] Description with file path`.

**Notation**:
- `[P]` = Parallelizable (can be done concurrently with other `[P]` tasks)
- `[US1]`, `[US2]`, `[US3]`, `[US4]` = Maps to user story priority
- No `[P]` = Sequential dependency, must complete before next phase

---

## Phase 1: Setup & Configuration

**Goal**: Configure Jekyll and create directory structure for the DJ mix hosting feature.

- [x] [T001] [P] Create `_djmixes/` collection directory at repository root
- [x] [T002] [P] Create `assets/waveforms/` directory for pre-generated waveform data
- [x] [T003] [P] Create `assets/images/mixes/teasers/` directory for mix cover thumbnails
- [x] [T004] [P] Create `assets/images/mixes/headers/` directory for mix header images
- [x] [T005] [P] Create `assets/js/` directory for JavaScript modules (if not exists)
- [x] [T006] [P] Create `assets/css/` directory for custom SCSS (if not exists)
- [x] [T007] Update `_config.yml` to add djmixes collection with permalink `/music/:name/`
- [x] [T008] Update `_config.yml` defaults to configure djmixes collection layout and options

**Acceptance**: Running `bundle exec jekyll serve` builds successfully with no collection configuration errors.

---

## Phase 2: Foundational - Core Dependencies

**Goal**: Set up WaveSurfer.js library and base layout infrastructure.

- [x] [T009] [US1] Research and document WaveSurfer.js v7 CDN URL or local installation approach in `_includes/wavesurfer-loader.html`
- [x] [T010] [US1] Create `_layouts/mix.html` as base layout for individual mix pages (extends Minimal Mistakes `single` layout)
- [x] [T011] [US1] Create `_layouts/mix-index.html` as layout for `/music/` listing page (extends Minimal Mistakes `archive` layout)
- [x] [T012] [US1] Create `_pages/music.md` to define `/music/` index page using `mix-index.html` layout
- [x] [T013] [P] [US1] Create `_sass/music-player.scss` for custom audio player styles
- [x] [T014] [P] [US1] Import `music-player.scss` in main SCSS file or add to site configuration

**Acceptance**: Mix pages render with base layout structure and WaveSurfer.js library loads without errors.

---

## Phase 3: User Story 1 (P1) - Listen to DJ Mix 🎯 MVP

**Goal**: Implement core audio playback functionality with cover art, controls, and tracklist display.

### 3.1: Audio Player Component

- [x] [T015] [US1] Create `_includes/audio-player.html` with waveform container div and control buttons (play/pause, volume)
- [x] [T016] [US1] Create `assets/js/audio-player.js` implementing AudioPlayer class per contract in `contracts/audio-player.md`
- [x] [T017] [US1] Implement `AudioPlayer.init()` method to initialize WaveSurfer with MediaElement backend
- [x] [T018] [US1] Implement `play()`, `pause()`, `seekTo()`, `getCurrentTime()`, `getDuration()` methods in AudioPlayer class
- [x] [T019] [US1] Implement event system (`on()` method) with support for 'play', 'pause', 'timeupdate', 'finish', 'error' events
- [x] [T020] [US1] Add error handling in AudioPlayer for audio loading failures with user-friendly error messages

### 3.2: Mix Page Layout

- [x] [T021] [US1] Update `_layouts/mix.html` to display mix front matter: title, date, cover art (header.image, header.teaser), genre, duration
- [x] [T022] [US1] Include `audio-player.html` in `_layouts/mix.html` with data attributes for audioUrl, waveformUrl, duration, mixId, mixTitle
- [x] [T023] [US1] Add page initialization script in `_layouts/mix.html` that calls `AudioPlayer.init()` with config from data attributes
- [x] [T024] [US1] Style mix page header with cover art using `music-player.scss` (full-width header image, overlay text)
- [x] [T025] [US1] Style audio player controls for desktop (play/pause buttons, volume slider, time display) in `music-player.scss`

### 3.3: Tracklist Display

- [x] [T026] [P] [US1] Create `_includes/tracklist.html` to render tracklist from page content (parse `[HH:MM:SS] Artist - Title` format)
- [x] [T027] [P] [US1] Include `tracklist.html` conditionally in `_layouts/mix.html` (only if tracklist content exists)
- [x] [T028] [P] [US1] Style tracklist display in `music-player.scss` (monospace timestamps, readable artist/title layout)

### 3.4: Mix Index Page

- [x] [T029] [US1] Implement `_layouts/mix-index.html` to loop through `site.djmixes` sorted by date (reverse chronological)
- [x] [T030] [US1] Display mix cards in grid layout with teaser image, title, date, genre, excerpt, and link to mix page
- [x] [T031] [US1] Style mix index grid for desktop in `music-player.scss` (responsive grid, card hover effects)

### 3.5: Mobile Responsiveness

- [x] [T032] [US1] Add CSS media queries in `music-player.scss` for mobile screens (320px+)
- [ ] [T033] [US1] Test and adjust audio player controls for touch interaction (larger tap targets, simplified layout)
- [ ] [T034] [US1] Test and adjust mix index grid for mobile (single column, card sizing)
- [ ] [T035] [US1] Test WaveSurfer responsive behavior on mobile devices (waveform width adjusts to viewport)

### 3.6: Example Mix Content

- [x] [T036] [US1] Create example mix file `_djmixes/2025-11-25-example-mix.md` with complete YAML front matter (all required fields)
- [ ] [T037] [US1] Upload example audio file to S3/CloudFront and add URL to example mix front matter (USER ACTION REQUIRED)
- [ ] [T038] [P] [US1] Generate example waveform using `audiowaveform -i example.mp3 -o assets/waveforms/example.dat -b 8 -z 256` (USER ACTION REQUIRED)
- [ ] [T039] [P] [US1] Add example cover art images to `assets/images/mixes/teasers/` and `assets/images/mixes/headers/` (USER ACTION REQUIRED)
- [x] [T040] [US1] Add example tracklist to `_djmixes/2025-11-25-example-mix.md` in correct format

### 3.7: Testing & Validation

- [ ] [T041] [US1] Test: Load `/music/` index page displays example mix in grid
- [ ] [T042] [US1] Test: Click mix card navigates to mix page with static URL
- [ ] [T043] [US1] Test: Mix page loads and displays cover art, title, metadata
- [ ] [T044] [US1] Test: Audio player play button starts playback within 5 seconds
- [ ] [T045] [US1] Test: Pause button stops playback and can resume from same position
- [ ] [T046] [US1] Test: Seek bar allows jumping to different timestamps
- [ ] [T047] [US1] Test: Tracklist displays when provided in mix file
- [ ] [T048] [US1] Test: Mix page functions fully without tracklist (optional field)
- [ ] [T049] [US1] Test: Mobile Safari (iOS) - full functionality
- [ ] [T050] [US1] Test: Mobile Chrome (Android) - full functionality
- [ ] [T051] [US1] Test: Audio player controls respond within 100ms (SC-002)
- [ ] [T052] [US1] Test: Audio loading error displays user-friendly error message (not console error)

**Acceptance**: A complete DJ mix page is functional on desktop and mobile with audio playback, cover art, and optional tracklist. Mix appears in `/music/` index. All User Story 1 acceptance scenarios pass.

---

## Phase 4: User Story 2 (P2) - Interactive Waveform Navigation

**Goal**: Add pre-generated waveform visualization with click-to-seek functionality.

- [ ] [T053] [US2] Update `AudioPlayer.init()` to fetch and load pre-generated waveform data from `config.waveformUrl`
- [ ] [T054] [US2] Implement waveform fallback logic: if waveform fetch fails (404), display simple progress bar instead
- [ ] [T055] [US2] Configure WaveSurfer waveform styling (colors, height) in `AudioPlayer.init()` (waveformColor: '#1976d2', progressColor: '#4caf50')
- [ ] [T056] [US2] Enable WaveSurfer click-to-seek interaction on waveform canvas
- [ ] [T057] [US2] Add visual playback progress indicator on waveform that updates during playback
- [ ] [T058] [US2] Style waveform container for desktop and mobile in `music-player.scss`
- [ ] [T059] [US2] Test: Waveform renders on mix page when `waveform_file` is present in front matter
- [ ] [T060] [US2] Test: Clicking waveform seeks audio to corresponding timestamp
- [ ] [T061] [US2] Test: Progress indicator updates smoothly during playback
- [ ] [T062] [US2] Test: Waveform fallback (progress bar) displays when waveform data missing or fails to load
- [ ] [T063] [US2] Test: Waveform responsive sizing on mobile devices (320px+ screens)

**Acceptance**: Mix pages display interactive waveform visualization. Clicking waveform seeks playback. Gracefully falls back to progress bar if waveform unavailable. All User Story 2 acceptance scenarios pass.

---

## Phase 5: User Story 3 (P3) - Live Track Highlighting

**Goal**: Automatically highlight current track in tracklist as playback progresses.

- [ ] [T064] [US3] Create `assets/js/track-highlighter.js` module with TrackHighlighter class
- [ ] [T065] [US3] Implement tracklist parsing logic to extract tracks with timestamps from page content (regex: `\[(\d{2}:\d{2}:\d{2})\] (.+?) - (.+?)`)
- [ ] [T066] [US3] Convert timestamp strings to seconds for comparison (e.g., "00:05:21" → 321)
- [ ] [T067] [US3] Implement `TrackHighlighter.init()` to parse tracklist and register with AudioPlayer 'timeupdate' events
- [ ] [T068] [US3] Implement highlighting logic: on timeupdate, find current track based on playback position and add CSS class
- [ ] [T069] [US3] Implement highlighting update on seek: when user seeks, immediately highlight correct track
- [ ] [T070] [US3] Add CSS styles in `music-player.scss` for highlighted track (background color, bold text, icon)
- [ ] [T071] [US3] Integrate TrackHighlighter in `_layouts/mix.html` page initialization (conditionally load if tracklist exists)
- [ ] [T072] [US3] Test: Track highlights when playback reaches its timestamp
- [ ] [T073] [US3] Test: Highlighting updates when playback moves to next track
- [ ] [T074] [US3] Test: Seeking updates highlighting immediately to correct track
- [ ] [T075] [US3] Test: Highlighting responds within 500ms of position change (SC-008)

**Acceptance**: Tracklist automatically highlights current track during playback. Highlighting updates on seek. All User Story 3 acceptance scenarios pass.

---

## Phase 6: User Story 4 (P4) - Persistent Playback Position

**Goal**: Save and restore playback position across browser sessions using localStorage.

- [ ] [T076] [US4] Create `assets/js/playback-persistence.js` module implementing PlaybackPersistence per contract in `contracts/playback-persistence.md`
- [ ] [T077] [US4] Implement `PlaybackPersistence.isAvailable()` to check localStorage availability (handles private browsing, disabled storage)
- [ ] [T078] [US4] Implement `PlaybackPersistence.savePosition()` with quota exceeded error handling (cleanup oldest 25% on QuotaExceededError)
- [ ] [T079] [US4] Implement `PlaybackPersistence.getPosition()` with expiration check (90-day TTL) and lazy cleanup of expired positions
- [ ] [T080] [US4] Implement storage data structure: `{ positions: { [mixId]: { position, duration, lastPlayed, title } }, version: 1 }`
- [ ] [T081] [US4] Integrate PlaybackPersistence in AudioPlayer: load saved position on init, restore if valid (>5s, <duration, <90 days old)
- [ ] [T082] [US4] Implement position saving during playback: throttled save every 10 seconds on 'timeupdate' event
- [ ] [T083] [US4] Implement position saving on pause and beforeunload events (critical saves)
- [ ] [T084] [US4] Add graceful degradation: if localStorage unavailable, player functions normally without position persistence
- [ ] [T085] [US4] Test: Play mix, pause partway, reload page → playback position restores
- [ ] [T086] [US4] Test: Play mix, close browser, reopen → position restores (if <90 days)
- [ ] [T087] [US4] Test: Multiple mixes maintain independent positions
- [ ] [T088] [US4] Test: Positions expire after 90 days (no longer restored)
- [ ] [T089] [US4] Test: localStorage disabled (private browsing) → player works without persistence (no errors)
- [ ] [T090] [US4] Test: Quota exceeded triggers cleanup and retry
- [ ] [T091] [US4] Test: Position saves and restores with 95% reliability (SC-009)

**Acceptance**: Playback positions save across browser sessions. Users can resume from where they left off. Graceful degradation when localStorage unavailable. All User Story 4 acceptance scenarios pass.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Goal**: Documentation, optimization, and final testing.

### 7.1: Documentation

- [ ] [T092] [P] Update `quickstart.md` with final workflow instructions (ensure S3/CloudFront setup steps are accurate)
- [ ] [T093] [P] Document any deviations from original plan in `plan.md` (if applicable)
- [ ] [T094] [P] Create optional automation script `scripts/add-mix.sh` as documented in quickstart.md section "Automation Ideas"

### 7.2: Performance & Optimization

- [ ] [T095] [P] Verify WaveSurfer.js loaded from CDN or minified local file (<100KB)
- [ ] [T096] [P] Compress waveform .dat files with gzip (if not already compressed by GitHub Pages)
- [ ] [T097] [P] Optimize cover art images (jpegoptim or similar) to reduce page load time
- [ ] [T098] Test: Mix page loads and begins playback within 5 seconds on standard broadband (SC-001)

### 7.3: Cross-Browser Testing

- [ ] [T099] Test: Chrome (desktop) - all features work
- [ ] [T100] Test: Firefox (desktop) - all features work
- [ ] [T101] Test: Safari (desktop) - all features work
- [ ] [T102] Test: Safari (iOS mobile) - all features work, touch controls responsive
- [ ] [T103] Test: Chrome (Android mobile) - all features work, touch controls responsive

### 7.4: Edge Cases & Error Handling

- [ ] [T104] Test: Audio file unavailable (404) → displays user-friendly error message (FR-018)
- [ ] [T105] Test: Unsupported audio format → displays error message
- [ ] [T106] Test: Extremely long mix (3+ hours) → player handles duration correctly
- [ ] [T107] Test: Mix with no tracklist → page functions fully, tracklist section hidden (FR-015)
- [ ] [T108] Test: Malformed tracklist timestamps → gracefully skips invalid lines, doesn't crash
- [ ] [T109] Test: Slow network / buffering → player shows loading state appropriately
- [ ] [T110] Test: Mobile autoplay restrictions → respects browser policies, shows play button

### 7.5: Final Validation

- [ ] [T111] Review all functional requirements (FR-001 through FR-018) and confirm implemented
- [ ] [T112] Review all success criteria (SC-001 through SC-010) and confirm met
- [ ] [T113] Test complete user journey: homepage → /music/ → mix page → play → seek → pause → reload → resume

**Acceptance**: All features implemented, tested, and documented. Site ready for production deployment.

---

## Summary

**Total Tasks**: 113
**Parallelizable Tasks**: 21 (marked with `[P]`)
**User Story Breakdown**:
- US1 (P1 - MVP): 38 tasks (T015-T052)
- US2 (P2 - Waveform): 11 tasks (T053-T063)
- US3 (P3 - Track Highlighting): 12 tasks (T064-T075)
- US4 (P4 - Persistence): 16 tasks (T076-T091)
- Setup & Foundation: 14 tasks (T001-T014)
- Polish & Testing: 22 tasks (T092-T113)

**Critical Path**: Phase 1 → Phase 2 → Phase 3 (US1) must complete before Phase 4-6 can begin. Phases 4, 5, and 6 are independent user stories and can be implemented in any order after Phase 3 completes.

**Recommended Implementation Order**:
1. Complete Phase 1-3 (Setup + US1 MVP) for immediate user value
2. Deploy MVP to production for early feedback
3. Implement Phase 4 (US2 - Waveform) for enhanced UX
4. Implement Phase 5 (US3 - Track Highlighting) for engagement
5. Implement Phase 6 (US4 - Persistence) for convenience
6. Complete Phase 7 (Polish) for production readiness

**Next Step**: Begin implementation with Phase 1 tasks, or review and adjust plan as needed.
