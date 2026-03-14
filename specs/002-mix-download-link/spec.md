# Feature Specification: Mix Download Link

**Feature Branch**: `002-mix-download-link`
**Created**: 2026-03-14
**Status**: Draft
**Input**: User description: "Add a download link to the djmix pages. It should display at the end of the mix description. By default it should simply download the audio_url unless an optional audio_download_url is provided"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Download Mix Audio (Priority: P1)

A visitor on a DJ mix page wants to save the mix to their device. They see a download link at the end of the mix description and click it to download the audio file.

**Why this priority**: Core feature — without this, the entire feature has no value.

**Independent Test**: Can be fully tested by visiting any mix page that has no `audio_download_url` set and clicking the download link, which should download the file at `audio_url`.

**Acceptance Scenarios**:

1. **Given** a mix page with no `audio_download_url` defined, **When** the visitor clicks the download link, **Then** the browser downloads the file at `audio_url`.
2. **Given** any mix page with an `audio_url`, **When** the page loads, **Then** a download link is visible at the end of the mix description.

---

### User Story 2 - Download from Custom Download URL (Priority: P2)

A visitor on a mix page that has a specific download URL (e.g., a higher-quality or separately-hosted file) clicks the download link and receives the file from that alternative URL.

**Why this priority**: Extends the core feature to support an explicit override; secondary to the baseline download behaviour.

**Independent Test**: Can be fully tested by visiting a mix page with `audio_download_url` set and clicking the download link, which should download the file at `audio_download_url` rather than `audio_url`.

**Acceptance Scenarios**:

1. **Given** a mix page with `audio_download_url` defined, **When** the visitor clicks the download link, **Then** the browser downloads the file at `audio_download_url`.
2. **Given** a mix page with `audio_download_url` defined, **When** the page loads, **Then** the download link points to `audio_download_url`, not `audio_url`.

---

### Edge Cases

- What happens when neither `audio_url` nor `audio_download_url` is set? The download link should not be rendered.
- What if the download URL points to a file on a different domain? The browser initiates a native download; no special handling required beyond using the standard download mechanism.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Each mix page MUST display a download link at the end of the mix description.
- **FR-002**: The download link MUST trigger a file download (not page navigation) when clicked.
- **FR-003**: By default, the download link MUST point to the mix's `audio_url`.
- **FR-004**: When a mix has `audio_download_url` defined, the download link MUST use `audio_download_url` instead of `audio_url`.
- **FR-005**: The `audio_download_url` field MUST be optional; existing mixes without it MUST continue to work correctly.
- **FR-006**: If neither `audio_url` nor `audio_download_url` is defined for a mix, the download link MUST NOT be rendered.

### Key Entities

- **DJ Mix**: A single mix entry with metadata including `audio_url` (required for playback) and the optional `audio_download_url` (explicit download source override).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A download link appears at the end of the mix description on every mix page that has an audio URL.
- **SC-002**: Clicking the download link initiates a file download in all major browsers without navigating away from the page.
- **SC-003**: Mixes with `audio_download_url` serve that file on download; mixes without it serve `audio_url`.
- **SC-004**: Existing mix pages with no changes to their front matter continue to display and function correctly after the feature is introduced.

## Assumptions

- The download link is a simple anchor element — no authentication, access control, or download counting is required.
- Visual styling of the link should match the existing site conventions; exact appearance (label text, icon) is an implementation detail.
- The `audio_url` field is assumed to be present for all published mixes; the download link is omitted gracefully when it is absent.
