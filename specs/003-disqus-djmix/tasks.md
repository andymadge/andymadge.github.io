# Tasks: Disqus Comments on DJ Mix Posts

**Input**: Design documents from `/specs/003-disqus-djmix/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, quickstart.md ✅

**Tests**: Not requested — no test tasks generated.

**Organization**: Single user story. Two parallelisable file changes.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to

---

## Phase 1: User Story 1 — Visitor Reads and Comments on a Mix (Priority: P1) 🎯 MVP

**Goal**: Disqus comment thread appears at the bottom of all DJ mix pages by default in production; "Comment on this mix" anchor link appears alongside "Download mix".

**Independent Test**:
- In development: visit any mix page at `http://localhost:4000` and confirm "Comment on this mix" link is present.
- In production: deploy and confirm Disqus thread renders at the bottom of a mix page.

### Implementation

- [x] T001 [P] [US1] Enable comments on djmix pages — in `_config.yml`, change `comments: false` to `comments: true` in the `_djmixes` default scope (line 141)
- [x] T002 [P] [US1] Add "Comment on this mix" anchor link — rewrite `_includes/mix-download.html` to include `<a href="#disqus_thread">Comment on this mix</a>` shown when `page.comments != false`, per the exact diff in `plan.md` (Change 2)

**Checkpoint**: Both file changes complete. Verify locally per `quickstart.md`.

---

## Phase 2: Polish & Verification

**Purpose**: Confirm everything works end-to-end before merging.

- [x] T003 Run `bundle exec jekyll serve` and confirm build completes without errors or warnings
- [x] T004 [P] Verify "Comment on this mix" link appears on a mix page at `http://localhost:4000`
- [x] T005 [P] Verify "Comment on this mix" link is absent on a mix page with `comments: false` in front matter (test by temporarily adding `comments: false` to any mix's front matter)
- [ ] T006 Merge to `master` and verify Disqus thread renders at the bottom of a mix page in production at `https://www.andymadge.com`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (US1)**: No blocking prerequisites — start immediately
- **Phase 2 (Polish)**: Depends on both T001 and T002 being complete

### User Story Dependencies

- **User Story 1 (P1)**: No dependencies on other stories. Only user story — this IS the MVP.

### Parallel Opportunities

- T001 and T002 modify different files and can be executed in parallel
- T004 and T005 are independent verification steps and can be run in parallel

---

## Implementation Strategy

### MVP (this feature IS the MVP)

1. Complete T001 and T002 in parallel
2. Run `bundle exec jekyll serve` — verify no build errors (T003)
3. Spot-check in browser (T004, T005)
4. Merge to `master` and verify in production (T006)

---

## Notes

- Disqus only renders in production (`jekyll.environment == "production"`), so the Disqus thread cannot be verified locally — only the "Comment on this mix" link visibility can be tested locally
- Exact template code for T002 is in `plan.md` under "Change 2"
- No new files, gems, plugins, or services required
