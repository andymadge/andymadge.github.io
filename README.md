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

- Ruby (version compatible with GitHub Pages)
- Bundler gem

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/andymadge/andymadge.github.io.git
   cd andymadge.github.io
   ```

2. Install dependencies:
   ```bash
   bundle install --path vendor/bundle
   ```

3. Run local server:
   ```bash
   bundle exec jekyll serve
   ```

4. View site at `http://localhost:4000`

### Building

```bash
bundle exec jekyll build
```

Output will be in `_site/` directory (excluded from git).

### Troubleshooting

**Multi-Architecture Development (Intel & Apple Silicon)**

If you work across both Intel and Apple Silicon Macs and encounter bundler or nokogiri errors, see [BUNDLE_SETUP.md](BUNDLE_SETUP.md) for detailed setup instructions for each architecture.

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

1. Test locally with `bundle exec jekyll serve`
2. Verify build completes without errors or warnings
3. Review all pages in browser at localhost:4000
4. Commit and push to `master` for automatic deployment

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
