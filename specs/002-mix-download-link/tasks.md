# Tasks: Mix Download Link

**Input**: Design documents from `/specs/002-mix-download-link/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, quickstart.md ✅

**Organization**: Tasks are grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to
- Exact file paths are included in every task description

---

## Phase 1: Setup

**Purpose**: Confirm the development environment is ready — no new project initialization needed (Jekyll project already exists).

- [x] T001 Verify dev server starts cleanly: `docker compose up` and confirm `http://localhost:4000` loads

---

## Phase 3: User Story 1 — Download Mix Audio (Priority: P1) 🎯 MVP

**Goal**: A visitor can click a download link at the end of the mix description to download the mix audio file (defaulting to `audio_url`).

**Independent Test**: Visit any mix page (e.g. `/djmixes/armchair-clubbing-vol01/`), scroll to the end of the description, click the download link, and confirm the browser downloads the file at `audio_url`.

### Implementation for User Story 1

- [x] T002 [US1] Create `_includes/mix-download.html` with a download anchor that resolves the URL using `{% assign download_url = page.audio_download_url | default: page.audio_url %}` and renders `<a href="{{ download_url }}" download>` (omitted entirely when both fields are absent)
- [x] T003 [US1] Update `_layouts/mix.html` to add `{% include mix-download.html %}` immediately after `{{ content }}` inside `<div id="mix-content">`

**Checkpoint**: After T003, visit any mix page — download link should appear at the end of the description and trigger a download of `audio_url` when clicked.

---

## Phase 4: User Story 2 — Download from Custom Download URL (Priority: P2)

**Goal**: When a mix specifies `audio_download_url` in its front matter, the download link uses that URL instead of `audio_url`.

**Independent Test**: Add `audio_download_url` to a test mix's front matter, visit the page, click the download link, and confirm the download targets `audio_download_url` not `audio_url`.

**Note**: The URL fallback logic (`| default:`) added in T002 already handles this story. T004 below only requires adding the field to a real mix to validate the override path.

### Implementation for User Story 2

- [x] T004 [US2] Validate the `audio_download_url` override by temporarily adding the field to a dev mix (e.g., `_djmixes/dev-2025-11-25-example-mix.md`) and confirming the download link targets the override URL

**Checkpoint**: Both US1 (default) and US2 (override) are confirmed working.

---

## Phase N: Polish & Cross-Cutting Concerns

- [x] T005 [P] Style the download link in `_sass/music-player.scss` to match site conventions (e.g., subtle placement, optional download icon via CSS `content`)
- [ ] T006 Run all four manual test scenarios from `specs/002-mix-download-link/quickstart.md` and confirm all pass
- [ ] T007 Verify `docker compose up` build produces zero errors or warnings

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **User Stories (Phase 3–4)**: Depend only on Phase 1 confirmation; stories share one include file so must be done sequentially
- **Polish (Phase N)**: Depends on both user stories complete

### User Story Dependencies

- **US1 (P1)**: Independent — no dependency on US2
- **US2 (P2)**: The include logic from US1 already handles US2; T004 is validation only

### Within Each User Story

- T002 (create include) must complete before T003 (reference include in layout)
- T003 must complete before manual browser validation

### Parallel Opportunities

- T001 can run while reviewing design documents
- T005 (styling) and T006 (quickstart validation) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Sequential (file dependency):
T002: Create _includes/mix-download.html
T003: Update _layouts/mix.html  ← depends on T002
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete T001: Confirm dev server
2. Complete T002–T003: Create include + wire into layout
3. **STOP and VALIDATE**: Download link appears and works on all mix pages
4. Deploy if ready — US2 is already supported by the fallback logic

### Incremental Delivery

1. T001–T003: Core download link (US1) → immediately deployable
2. T004: Validate override URL (US2) → no code change, front-matter only
3. T005–T007: Polish and final validation

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps each task to a specific user story for traceability
- US2 requires no additional code — the `| default:` filter in T002 handles both stories
- No new JS, gems, plugins, or dependencies introduced
- Commit after T003 (working MVP) and after T005–T007 (polished)
