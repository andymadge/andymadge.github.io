# Quickstart: Mix Download Link

**Branch**: `002-mix-download-link` | **Date**: 2026-03-14

## Prerequisites

- Docker Desktop running
- Checked out on branch `002-mix-download-link`

## Running the dev server

```bash
docker compose up
```

Site available at `http://localhost:4000`. LiveReload is enabled — template changes refresh automatically.

## Testing the feature

### Test 1 — Default download (no override)

1. Open any mix page, e.g. `http://localhost:4000/djmixes/armchair-clubbing-vol01/`
2. Scroll to the end of the mix description.
3. Verify a download link is visible.
4. Click it — browser should download (or prompt to save) the file at `audio_url`.

### Test 2 — Download URL override

1. Add `audio_download_url` to a mix's front matter:
   ```yaml
   audio_download_url: "https://example.com/download/mix.mp3"
   ```
2. Restart or wait for LiveReload.
3. Visit the mix page and click the download link.
4. Verify the download targets `audio_download_url`, not `audio_url`.

### Test 3 — No audio URL (edge case)

1. Temporarily remove `audio_url` from a dev/test mix front matter.
2. Verify the download link is not rendered on that mix page.
3. Restore `audio_url` after testing.

### Test 4 — Backwards compatibility

1. Visit a mix page that has not been modified (no `audio_download_url` field).
2. Verify the page renders correctly and the download link points to `audio_url`.

## Files to modify

| File | Change |
|------|--------|
| `_includes/mix-download.html` | Create new include with download link Liquid |
| `_layouts/mix.html` | Add `{% include mix-download.html %}` after `{{ content }}` inside `#mix-content` |
| `_djmixes/*.md` | Optionally add `audio_download_url` to any mix that needs a custom download URL |
| `_sass/music-player.scss` | Optional: style the download link |

## Commit checklist

- [ ] `docker compose up` builds without errors or warnings
- [ ] Download link appears at end of description on all mix pages with `audio_url`
- [ ] Download link is absent on mix pages with no `audio_url`
- [ ] Override URL is used when `audio_download_url` is set
- [ ] Existing pages unaffected (no visual regressions)
