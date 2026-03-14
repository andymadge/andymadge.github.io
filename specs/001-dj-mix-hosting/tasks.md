# Tasks: DJ Mix Hosting

**Input**: Design documents from `/specs/001-dj-mix-hosting/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅
**Generated**: 2026-02-21

**Organization**: Tasks target only confirmed outstanding gaps per `plan.md`. Tasks are grouped by user story.

## Status Note

Per `plan.md`, the core feature (P1–P4, FR-001–FR-027) is **predominantly built**. Tasks below address only the confirmed remaining gaps:

| Gap | Requirement | Affected Story |
|-----|-------------|---------------|
| Loading state UI not confirmed in `audio-player.js` | FR-005 | US1 |
| No `text-decoration: none` confirmed on `.mix-card` | FR-029 | US1 |
| Emoji icons on metadata labels not removed | FR-030 | US1 |
| Date format not confirmed as `YYYY/MM/DD` | FR-031 | US1 |
| Duration field shown on mix cards — should be omitted | FR-032 | US1 |
| `.mix-image-caption` has `font-size` override — should inherit | FR-033 | US1 |
| `playback-persistence.js` has 90-day TTL — should be indefinite + LRU cap 20 | FR-012 | US4 |
| WaveSurfer.js CDN pinned at `@7` (minor version float) | Constitution | US1+US2 |

**US2 (Interactive Waveform) and US3 (Live Track Highlighting)** have no outstanding items and are fully implemented.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: Which user story this task belongs to
- Exact file paths are included in all descriptions

---

## Phase 1: Setup

**Purpose**: Pin the WaveSurfer.js CDN to an exact semver to eliminate the minor-version float risk identified in the Constitution check. This blocks both US1 (audio player) and US2 (waveform).

- [x] T001 Check jsDelivr for the latest stable WaveSurfer.js `7.x.y` release and update the CDN `<script>` tag from `@7` to the exact version (e.g. `@7.8.6`) in `_includes/wavesurfer-loader.html`

---

## Phase 2: User Story 1 — Listen to a DJ Mix (Priority: P1) 🎯

**Goal**: Complete the remaining mix page and mix index UI requirements so the core listening experience is fully spec-compliant.

**Independent Test**: Run `bundle exec jekyll serve` and verify:
1. Click play on a mix page → loading spinner appears on play button, controls are disabled until audio is ready to play
2. Visit `/music/` → no emoji in metadata, dates display as `YYYY/MM/DD`, no duration on cards, cards fit more per row on wide screens, no underlines on any card text

### Implementation for User Story 1

- [x] T002 [P] [US1] Add loading spinner on play button and disable all transport controls until WaveSurfer `ready` event fires in `assets/js/audio-player.js` (FR-005)
- [x] T003 [P] [US1] Apply mix index SCSS fixes in `_sass/music-player.scss`: add `text-decoration: none` to `.mix-card` and all descendant text elements (FR-029); remove any explicit `font-size` property from `.mix-image-caption` so it inherits body font size (FR-033). Note: `.mix-grid` min card width of 280px was visually validated and confirmed correct — 180px was tested and rejected as too narrow.
- [x] T004 [P] [US1] Apply mix index HTML fixes in `_layouts/mix-index.html`: remove emoji characters from all metadata label text (date, genre, duration) (FR-030); format the mix date output as `YYYY/MM/DD` with zero-padded month and day using the Liquid `date` filter (FR-031); remove the duration/length field entirely from the mix card display (FR-032)

**Checkpoint**: After T002–T004, User Story 1 is fully functional and spec-compliant.

---

## Phase 3: User Story 4 — Persistent Playback Position (Priority: P4)

**Goal**: Correct the localStorage TTL policy to match the spec — positions stored indefinitely, evicted only when the LRU cap of 20 entries is exceeded.

**Independent Test**: Play a mix to >5 seconds, pause, reload the page — the position restores. Play 20+ different mixes and verify the oldest entry is evicted (not a time-based expiry).

### Implementation for User Story 4

- [x] T005 [US4] Remove the 90-day `EXPIRATION_MS` constant and all TTL-based expiry logic from `assets/js/playback-persistence.js`: delete `isExpired()` checks in `getPosition()` and `cleanExpired()` calls; replace with pure LRU eviction — before saving a new position, if `Object.keys(data.positions).length >= MAX_POSITIONS`, delete the entry with the smallest `lastPlayed` value (FR-012)

**Checkpoint**: After T005, positions persist indefinitely. LRU cap of 20 entries is the only eviction trigger. No 90-day TTL.

---

## Phase 4: Polish & Cross-Cutting Concerns

**Purpose**: Final validation across all changes before deployment.

- [x] T006 Run `bundle exec jekyll serve` and manually verify all outstanding gaps from `plan.md` are resolved: loading state (FR-005), mix grid width (FR-028), no underlines (FR-029), no emoji (FR-030), `YYYY/MM/DD` date (FR-031), no duration on cards (FR-032), caption font inheritance (FR-033), localStorage TTL removed (FR-012), WaveSurfer CDN version pinned (T001)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (US1)**: Can start in parallel with Phase 1 (different files); T002, T003, T004 are mutually parallel
- **Phase 3 (US4)**: Can start in parallel with Phases 1 and 2 (different file: `playback-persistence.js`)
- **Phase 4 (Polish)**: Depends on all prior phases complete

### User Story Dependencies

- **US1**: No dependencies on US2, US3, or US4
- **US4**: No dependencies on US1, US2, or US3
- **US2 and US3**: Already fully implemented — no tasks required

### Within Phase 2

T002, T003, and T004 are all `[P]` — they touch different files with no inter-dependencies:
- T002 → `assets/js/audio-player.js`
- T003 → `_sass/music-player.scss`
- T004 → `_layouts/mix-index.html`

---

## Parallel Execution Example

```bash
# All tasks from Phases 1, 2, and 3 can run concurrently:

Task T001: Pin WaveSurfer.js CDN in _includes/wavesurfer-loader.html
Task T002: Add loading state in assets/js/audio-player.js        [P]
Task T003: SCSS fixes in _sass/music-player.scss                  [P]
Task T004: HTML fixes in _layouts/mix-index.html                  [P]
Task T005: Fix localStorage TTL in assets/js/playback-persistence.js

# Then:
Task T006: Final validation (bundle exec jekyll serve)
```

---

## Implementation Strategy

### Minimal Scope (All Outstanding Items)

All 6 tasks are small, focused changes in existing files. Recommended order for a single developer:

1. **T001** — Pin WaveSurfer CDN (1 line change in `_includes/wavesurfer-loader.html`)
2. **T002** — Loading state UI in `assets/js/audio-player.js`
3. **T003** — SCSS fixes in `_sass/music-player.scss` (3 targeted CSS rule changes)
4. **T004** — HTML fixes in `_layouts/mix-index.html` (3 Liquid template changes)
5. **T005** — Remove TTL from `assets/js/playback-persistence.js`
6. **T006** — Final browser validation

### Key Constraints

- No new files need to be created — all changes are in existing files
- No automated test suite — validate manually via `bundle exec jekyll serve` + browser
- T003 groups 3 SCSS changes into one task to avoid repeated edits to the same file
- The 90-day `EXPIRATION_MS` constant in `playback-persistence.js` should be **removed entirely**, not just set to a larger value

---

## Summary

| Metric | Value |
|--------|-------|
| Total tasks | 6 |
| Parallelizable tasks | 3 (T002, T003, T004) |
| Tasks for US1 | 3 (T002, T003, T004) |
| Tasks for US4 | 1 (T005) |
| Tasks for US2 | 0 (fully implemented) |
| Tasks for US3 | 0 (fully implemented) |
| Setup tasks | 1 (T001) |
| Polish tasks | 1 (T006) |
| Files affected | 5 |
