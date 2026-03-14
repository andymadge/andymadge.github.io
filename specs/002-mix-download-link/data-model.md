# Data Model: Mix Download Link

**Branch**: `002-mix-download-link` | **Date**: 2026-03-14

## Overview

This feature introduces one optional field to the existing DJ Mix entity. No new collections, files, or storage mechanisms are added.

---

## Entity: DJ Mix (existing — `_djmixes/*.md` YAML front matter)

### Existing relevant fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `audio_url` | String (URL) | Yes | Audio stream URL used by the player and as the default download source |

### New field

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `audio_download_url` | String (URL) | No | `nil` | Override URL for the download link. When absent, `audio_url` is used instead. |

### Validation rules

- `audio_download_url`, when provided, MUST be a valid URL string.
- If both `audio_url` and `audio_download_url` are absent, the download link MUST NOT render.
- The field has no effect on audio playback — it is display/download only.

### Example front matter (with override)

```yaml
---
title: "My Mix"
audio_url: "https://example.com/stream/mix.mp3"
audio_download_url: "https://example.com/download/mix-hq.mp3"
---
```

### Example front matter (default — no change needed)

```yaml
---
title: "My Mix"
audio_url: "https://example.com/stream/mix.mp3"
---
```

---

## Template data flow

```
page.audio_download_url  ──┐
                            ├──► download_url ──► <a href="{download_url}" download>
page.audio_url  ────────────┘   (Liquid default filter)
```

The resolved `download_url` value is used as both the `href` and the `download` attribute target of the anchor element.
