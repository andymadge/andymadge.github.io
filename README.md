# Andy Madge Personal Blog

Personal technical blog and knowledge repository hosted at [www.andymadge.com](https://www.andymadge.com)

## Purpose

This blog serves as a centralized location for technical reference material, solutions, and personal knowledge. Content is primarily written for personal reference with the secondary benefit of sharing useful information with others through organic search discovery.

> "This blog is going to be a place for me to keep things that I may want to refer back to later, or for answers to specific questions people have asked me." - About page

## Technologies

### Core Framework

- **Jekyll** - Static site generator (Ruby-based)
- **GitHub Pages** - Hosting platform with automatic deployment on push to `master`
- **Bundler** - Ruby dependency management

### Theme & Design

- **[Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/)** v4.19.3 (remote theme)
- **Skin**: "air" variant
- **Custom SCSS**: Overrides in `/assets/css/main.scss`
- **Liquid** - Template engine

### Content Format

- **Markdown** - All blog posts and pages (kramdown processor)
- **YAML** - Front matter and configuration
- **HTML** - Template overrides

### Jekyll Plugins

| Plugin | Purpose |
|--------|---------|
| `jekyll-paginate` | 10 posts per page at `/page:num/` |
| `jekyll-sitemap` | Automatic XML sitemap generation |
| `jekyll-feed` | RSS feed at `/feed.xml` |
| `jekyll-gist` | Embed GitHub Gists in posts |
| `jemoji` | Emoji shortcode support |
| `jekyll-include-cache` | Performance optimization |
| `jekyll-algolia` | Site-wide search functionality |

### Third-Party Services

- **Disqus** - Comment system
- **Google Analytics** - Visitor tracking (gtag)
- **Full-text search** - Built-in search across all content

## Project Structure

```
andymadge.github.io/
├── _posts/              # 66 published blog posts (2006-2020)
├── _drafts/             # 11 unpublished draft posts
├── _pages/              # Static pages (About, Archives, 404)
│   ├── about.md
│   ├── category-archive.md
│   ├── tag-archive.md
│   ├── year-archive.md
│   └── 404.md
├── _data/               # Site data files
│   └── navigation.yml   # Main navigation menu
├── assets/
│   ├── css/             # SCSS customizations
│   │   └── main.scss
│   └── images/          # All image assets
│       ├── bio-photo.jpg
│       └── header-images/
├── _config.yml          # Main Jekyll configuration
├── Gemfile              # Ruby dependencies
├── Gemfile.lock         # Locked dependency versions
├── CNAME                # Custom domain (www.andymadge.com)
├── index.html           # Homepage
├── .gitignore           # Git ignore rules
├── .claude/             # Claude Code integration
└── .specify/            # Project specifications and constitution
```

## Content Organization

### Blog Posts

- **Location**: `_posts/`
- **Naming convention**: `YYYY-MM-DD-title.md`
- **Date range**: May 2006 - June 2020 (14+ years)
- **Count**: 66 published posts

### Front Matter Structure

Every post includes:
```yaml
---
title: "Post Title"
categories:
  - Category Name
tags:
  - tag1
  - tag2
header:
  image: assets/images/header-images/image.jpg  # Optional
toc: true  # Optional: Table of contents
---
```

### Content Categories

Technical reference material covering:

- **Infrastructure & DevOps**: Docker, Elasticsearch, cron jobs, iperf
- **Cloud & Systems**: AWS, Ubuntu, Windows administration
- **Version Control**: Git, TortoiseSVN
- **Development Tools**: MySQL, portable applications
- **Networking**: macvlan, WiFi QR codes, DNS
- **General Computing**: Security, privacy, productivity

## Local Development

### Prerequisites

- Docker Desktop

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/andymadge/andymadge.github.io.git
   cd andymadge.github.io
   ```

2. Start the development server:
   ```bash
   docker compose up
   ```

3. View site at `http://localhost:4000`

LiveReload is enabled — the browser refreshes automatically when files change.

### First run

On the first run, Docker will build the image and install all gems into a named volume. This takes a few minutes. Subsequent starts are fast.

```bash
docker compose up --build  # rebuild image (e.g. after Gemfile changes)
docker compose down        # stop and remove the container
```

### Extra Jekyll arguments (Docker)

Pass additional `jekyll serve` flags via the `JEKYLL_EXTRA_ARGS` environment variable. This can be done as a one-off command or by editing `compose.yml` for persistent configuration.

**`--livereload`** — Auto-refreshes the browser when source files change. **`--port <number>`** — Changes the port Jekyll listens on (default: `4000`).

```bash
# Preview draft posts
JEKYLL_EXTRA_ARGS="--drafts" docker compose up

# Custom port (useful if 4000 is already in use)
JEKYLL_EXTRA_ARGS="--port 4001" docker compose up

# Combine flags
JEKYLL_EXTRA_ARGS="--drafts --port 4001" docker compose up

# Persistent configuration (edit compose.yml)
JEKYLL_EXTRA_ARGS: "--drafts"
```

### Building (without serving)

```bash
docker compose run --rm jekyll bundle exec jekyll build
```

Output will be in `_site/` directory (excluded from git).

## Configuration

### Site Settings (_config.yml)

- **Title**: Andy Madge
- **Subtitle**: "Nothing much to see here, move along..."
- **Repository**: andymadge/andymadge.github.io
- **Permalink format**: `/:year/:month/:day/:title/`
- **Timezone**: Europe/London
- **Locale**: en-GB
- **Search**: Enabled with full-content indexing

### Author Information

- **Name**: Andy Madge
- **Bio**: Senior Engineering Manager - Solution Architect, DevOps, AWS, Python
- **Location**: London, UK
- **Social Links**: LinkedIn, GitHub, Stack Exchange, Twitter

### Navigation

Main navigation menu defined in `_data/navigation.yml`:
- Posts (homepage)
- Categories archive
- Tags archive
- About page

## Deployment

### Automatic Deployment

- **Trigger**: Push to `master` branch
- **Platform**: GitHub Pages
- **URL**: https://www.andymadge.com
- **Build**: Automatic via GitHub Pages infrastructure

### Testing Changes

1. Run `docker compose up` and verify build completes without errors
2. Review all modified pages in browser at `http://localhost:4000`
3. Commit and push to `master` for automatic deployment

## Content Guidelines

Per the [project constitution](.specify/memory/constitution.md):

### Core Principles

1. **Content-First**: Prioritize content accessibility and readability
2. **Simplicity**: Use standard Jekyll/theme features, avoid custom complexity
3. **Static Site**: Maintain static architecture, no server-side processing
4. **Backwards Compatibility**: Preserve existing URLs and content
5. **Minimal Dependencies**: Pin versions, justify new dependencies

### Quality Standards

- Technical accuracy takes priority over publishing speed
- Code examples must be tested and functional
- External links should be checked periodically
- Posts should include context and rationale, not just procedures

## Project History

- **Started**: May 2006
- **Latest post**: June 2020
- **Total posts**: 66 published, 11 drafts
- **Theme migration**: Switched to Minimal Mistakes with version pinning (commit f7b9765)
- **Constitution established**: November 2025 (v1.0.0)

## Theme Documentation

For theme customization options, see the [Minimal Mistakes documentation](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/) or the original theme starter README at `upstream_README.md`.

## License

Content and original code are the property of Andy Madge. The Minimal Mistakes theme is licensed under the MIT License.

---

## Appendix: Running without Docker

> These commands require a local Ruby installation compatible with GitHub Pages. Docker is the recommended approach.

**Prerequisites**: Ruby, Bundler (`gem install bundler`)

```bash
# Install dependencies
bundle install

# Run development server
bundle exec jekyll serve

# Run with live reload (auto-refreshes browser on file changes)
bundle exec jekyll serve --livereload

# Run on a custom port (default is 4000)
bundle exec jekyll serve --port 4001

# Combine options
bundle exec jekyll serve --livereload --port 4001

# Run with drafts
bundle exec jekyll serve --drafts

# Build only
bundle exec jekyll build
```

**`--livereload`** — Injects a small script into served pages that opens a WebSocket connection back to Jekyll. When a source file changes, Jekyll rebuilds and the browser refreshes automatically — no manual reload needed.

**`--port <number>`** — Changes the port Jekyll listens on (default: `4000`). Useful when something else is already using port 4000.

If you encounter native extension errors (e.g. nokogiri) when switching between Intel and Apple Silicon Macs, clean and reinstall:

```bash
rm -rf vendor/bundle .bundle
bundle install
```
