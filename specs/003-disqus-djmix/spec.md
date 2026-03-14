# Feature Specification: Disqus Comments on DJ Mix Posts

**Feature Branch**: `003-disqus-djmix`
**Created**: 2026-03-14
**Status**: Draft
**Input**: User description: "Disqus is enabled for blog posts, please also add it to djmix posts"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Visitor Reads and Comments on a Mix (Priority: P1)

A visitor views a DJ mix page and wants to leave a comment or read existing comments. They scroll past the tracklist/player to find a Disqus comment thread at the bottom of the page, just as they would on a blog post.

**Why this priority**: This is the entire feature — enabling community engagement on mix pages.

**Independent Test**: Navigate to any DJ mix page in production and verify a Disqus comment thread appears at the bottom.

**Acceptance Scenarios**:

1. **Given** a visitor views any DJ mix page in the production environment, **When** they scroll to the bottom, **Then** a Disqus comment thread is visible below the mix content.
2. **Given** a DJ mix page with no front matter `comments` override, **When** the page renders, **Then** Disqus is shown by default.
3. **Given** a DJ mix page with `comments: false` in its front matter, **When** the page renders, **Then** no Disqus thread appears (per-post opt-out still works).

---

### Edge Cases

- What happens when a mix has `comments: false` explicitly set in its front matter? → Disqus must be suppressible per-post.
- Disqus only renders in production (not in development server) — this is existing behaviour shared with blog posts and is expected.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Disqus comments MUST appear on all DJ mix pages by default.
- **FR-002**: Individual mix pages MUST be able to suppress comments by setting `comments: false` in their front matter.
- **FR-003**: The Disqus shortname used MUST be the same as that used for blog posts (`andymadge`).
- **FR-004**: Comments MUST only render in the production environment (consistent with blog post behaviour).
- **FR-005**: The Disqus thread identifier for each mix page MUST be unique and stable (based on the page URL).
- **FR-006**: A "Comment on this mix" link MUST appear alongside the "Download mix" link on mix pages where comments are enabled.
- **FR-007**: Clicking "Comment on this mix" MUST scroll the page to the Disqus comment section.
- **FR-008**: The "Comment on this mix" link MUST NOT appear on mix pages where `comments: false` is set.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A Disqus comment thread appears at the bottom of every DJ mix page when viewed in production.
- **SC-002**: No Disqus thread appears on mix pages viewed via the local development server.
- **SC-003**: A mix with `comments: false` in its front matter shows no comment thread and no "Comment on this mix" link.
- **SC-004**: The same Disqus account (shortname) is used across both blog posts and mix pages — no new account or configuration required.
- **SC-005**: Clicking "Comment on this mix" scrolls the visitor directly to the comment thread without a page reload.

## Assumptions

- The Minimal Mistakes `single` layout (which `mix.html` wraps via `layout: single`) already renders Disqus when `page.comments` is truthy and `site.comments.provider` is set — no layout changes are needed beyond enabling the flag.
- The only required change is removing the explicit `comments: false` from the `_djmixes` scope defaults in `_config.yml` (or changing it to `true`).
- No new Disqus configuration, shortname, or include files are needed.
