# andymadge.github.io Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-11-25

## Active Technologies
- Ruby / Jekyll 3.9+ (GitHub Pages gem), JavaScript ES6+, Liquid templates, SCSS + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, optional dev-time), HTML5 Audio API (browser-native) (001-dj-mix-hosting)
- Jekyll collection files (`_djmixes/*.md` YAML front matter), browser localStorage (playback positions, LRU cap 20 mixes), filesystem binary assets (`assets/djmixes/{slug}/waveform.dat`) (001-dj-mix-hosting)
- Ruby (Jekyll 3.9+ via GitHub Pages gem), JavaScript ES6+ + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, dev-time optional) (001-dj-mix-hosting)
- Jekyll collection files (`_djmixes/*.md` YAML front matter); browser localStorage (playback positions, LRU cap 20 mixes); filesystem binary assets (`assets/djmixes/{slug}/waveform.dat`) (001-dj-mix-hosting)
- Ruby 3.x / Jekyll 3.9+ (GitHub Pages gem); Liquid templating; HTML5 + Jekyll (via `github-pages` gem) — no new dependencies (002-mix-download-link)
- YAML front matter in `_djmixes/*.md` files (new optional field `audio_download_url`) (002-mix-download-link)

- Ruby 2.x+ (Jekyll 3.9+), JavaScript (ES6+), HTML5, CSS3 (001-dj-mix-hosting)

## Project Structure

```text
_djmixes/          # Jekyll collection: one .md file per mix
_layouts/          # mix.html, mix-index.html
_includes/         # audio-player.html, tracklist.html, mix-cover.html, mix-image.html, wavesurfer-loader.html
_sass/             # music-player.scss
assets/js/         # audio-player.js, playback-persistence.js, track-highlighter.js
assets/djmixes/    # per-mix waveform .dat files
scripts/           # add-mix.sh, generate-waveforms.sh
```

## Commands

**Development server** (native Ruby — preferred):
```bash
bundle install             # first time or after Gemfile changes
bundle exec jekyll serve --livereload  # start dev server at http://localhost:4000
```

**Development server** (Docker — alternative):
```bash
docker compose up          # start dev server at http://localhost:4000
docker compose up --build  # rebuild image first (after Gemfile changes)
docker compose down        # stop
```

**Build only** (native):
```bash
bundle exec jekyll build
```

**Build only** (Docker):
```bash
docker compose run --rm jekyll bundle exec jekyll build
```

## Code Style

Ruby (Jekyll 3.9+), JavaScript ES6+, Liquid, SCSS: follow standard conventions for each language

## Recent Changes
- 002-mix-download-link: Added Ruby 3.x / Jekyll 3.9+ (GitHub Pages gem); Liquid templating; HTML5 + Jekyll (via `github-pages` gem) — no new dependencies
- 001-dj-mix-hosting: Added Ruby (Jekyll 3.9+ via GitHub Pages gem), JavaScript ES6+ + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, dev-time optional)
- 001-dj-mix-hosting: Added Ruby / Jekyll 3.9+ (GitHub Pages gem), JavaScript ES6+, Liquid templates, SCSS + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, optional dev-time), HTML5 Audio API (browser-native)


<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
