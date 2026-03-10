# andymadge.github.io Development Guidelines

Auto-generated from all feature plans. Last updated: 2025-11-25

## Active Technologies
- Ruby / Jekyll 3.9+ (GitHub Pages gem), JavaScript ES6+, Liquid templates, SCSS + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, optional dev-time), HTML5 Audio API (browser-native) (001-dj-mix-hosting)
- Jekyll collection files (`_djmixes/*.md` YAML front matter), browser localStorage (playback positions, LRU cap 20 mixes), filesystem binary assets (`assets/djmixes/{slug}/waveform.dat`) (001-dj-mix-hosting)

- Ruby 2.x+ (Jekyll 3.9+), JavaScript (ES6+), HTML5, CSS3 (001-dj-mix-hosting)

## Project Structure

```text
backend/
frontend/
tests/
```

## Commands

npm test && npm run lint

## Code Style

Ruby 2.x+ (Jekyll 3.9+), JavaScript (ES6+), HTML5, CSS3: Follow standard conventions

## Recent Changes
- 001-dj-mix-hosting: Added Ruby / Jekyll 3.9+ (GitHub Pages gem), JavaScript ES6+, Liquid templates, SCSS + WaveSurfer.js v7 (jsDelivr CDN `@7`), BBC `audiowaveform` CLI (waveform generation, dev-time only), `ffprobe` (duration extraction, optional dev-time), HTML5 Audio API (browser-native)

- 001-dj-mix-hosting: Added Ruby 2.x+ (Jekyll 3.9+), JavaScript (ES6+), HTML5, CSS3

<!-- MANUAL ADDITIONS START -->
<!-- MANUAL ADDITIONS END -->
