<!--
Sync Impact Report:
Version Change: 1.0.0 → 1.0.1
Modified Principles: None (clarifications only)
Added Sections:
  - Technology Stack (new section specifying approved technologies)
  - Local Development (new section with build requirements)
Removed Sections: None
Enhanced Sections:
  - Jekyll Configuration: Added specific theme version and approved plugins list
  - Content Standards: Added specific content category examples
  - Deployment and Testing: Added specific testing steps
Templates Status:
  ✅ .specify/templates/plan-template.md - reviewed, no updates needed
  ✅ .specify/templates/spec-template.md - reviewed, no updates needed
  ✅ .specify/templates/tasks-template.md - reviewed, no updates needed
  ✅ README.md - already references this constitution
Follow-up TODOs: None
-->

# Andy Madge Personal Blog Constitution

**Project URL**: [www.andymadge.com](https://www.andymadge.com)
**Repository**: andymadge/andymadge.github.io
**Project Started**: May 2006

## Core Principles

### I. Content-First Architecture

The primary purpose of this site is to publish and organize technical content. All features, configurations, and modifications MUST prioritize content accessibility, readability, and maintainability. Content MUST be stored in plain text formats (Markdown) that remain accessible independent of any specific platform or tool.

**Rationale**: A personal blog's value lies in its content, not its technical complexity. Content must remain portable and future-proof.

### II. Simplicity and Maintainability

Solutions MUST be simple, standard, and well-documented. Avoid custom code, complex configurations, or non-standard approaches when standard Jekyll/theme features exist. Every dependency and customization increases maintenance burden and MUST be justified.

**Rationale**: This is a personal project maintained by a single person with limited time. Complexity creates technical debt that diverts energy from content creation.

### III. Static Site Performance

The site MUST remain a static site built with Jekyll. No server-side processing, databases, or dynamic content generation should be introduced. All functionality MUST leverage GitHub Pages native capabilities and standard Jekyll plugins.

**Rationale**: Static sites provide security, performance, reliability, and zero-cost hosting through GitHub Pages. Dynamic features compromise these benefits.

### IV. Backwards Compatibility

Changes to theme configurations, permalinks, or site structure MUST maintain backwards compatibility with existing URLs and content. Existing blog posts MUST continue to work without modification unless explicitly required.

**Current permalink format**: `/:year/:month/:day/:title/` (MUST be preserved)

**Rationale**: External links, search engine indexing, and reader bookmarks depend on URL stability. Breaking changes damage discoverability and user trust.

### V. Minimal Dependencies

Dependencies (themes, plugins, gems) MUST be pinned to specific versions. New dependencies should only be added when they provide clear, substantial value that cannot be achieved with existing tools. Prefer Jekyll-native features over third-party plugins.

**Rationale**: Dependency updates can break builds unexpectedly. Version pinning ensures reproducible builds and controlled upgrades.

## Technology Stack

### Approved Core Technologies

- **Jekyll**: Static site generator (Ruby-based)
- **GitHub Pages**: Hosting platform with automatic deployment
- **Bundler**: Ruby dependency management
- **Markdown**: Content format (kramdown processor)
- **YAML**: Front matter and configuration
- **Liquid**: Template engine

### Approved Theme

- **Theme**: [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/) v4.19.3
- **Skin**: "air" variant
- **Custom SCSS**: Permitted only in `/assets/css/main.scss` for essential overrides

### Approved Jekyll Plugins

Only GitHub Pages-compatible plugins are permitted:

| Plugin | Purpose | Status |
|--------|---------|--------|
| `jekyll-paginate` | Pagination (10 posts per page) | Required |
| `jekyll-sitemap` | XML sitemap generation | Required |
| `jekyll-feed` | RSS feed generation | Required |
| `jekyll-gist` | GitHub Gist embedding | Optional |
| `jemoji` | Emoji shortcode support | Optional |
| `jekyll-include-cache` | Performance optimization | Recommended |
| `jekyll-algolia` | Site-wide search | Optional |

New plugins MUST be GitHub Pages-compatible and provide clear value.

### Approved Third-Party Services

- **Disqus**: Comment system (configured with shortname: "andymadge")
- **Google Analytics**: Visitor tracking (gtag format)
- **Built-in search**: Full-text search across content

New third-party services MUST NOT compromise static site principles or user privacy.

## Content Standards

### Content Organization

- Blog posts MUST be stored in `_posts/` following Jekyll's date-based naming convention: `YYYY-MM-DD-title.md`
- Draft posts MAY be stored in `_drafts/` without date prefixes
- Static pages MUST be stored in `_pages/` with appropriate front matter
- All content MUST use Markdown format with YAML front matter
- Images and assets MUST be stored in `assets/images/` with descriptive filenames
- Header images SHOULD be stored in `assets/images/header-images/`

### Front Matter Requirements

Every post MUST include:
```yaml
---
title: "Clear, descriptive post title"
categories:
  - Category Name
tags:
  - tag1
  - tag2
---
```

Posts MAY include:
```yaml
header:
  image: assets/images/header-images/image.jpg
toc: true  # Table of contents
```

### Content Scope

This blog focuses on technical reference material across established domains:

- **Infrastructure & DevOps**: Docker, Elasticsearch, cron jobs, iperf
- **Cloud & Systems**: AWS, Ubuntu, Windows administration
- **Version Control**: Git, TortoiseSVN
- **Development Tools**: MySQL, portable applications
- **Networking**: macvlan, WiFi QR codes, DNS
- **General Computing**: Security, privacy, productivity

New content areas SHOULD align with the author's professional expertise and personal reference needs.

### Content Quality

- Technical accuracy takes priority over publishing speed
- Code examples MUST be tested and functional
- External links SHOULD be checked periodically for validity
- Posts SHOULD include context and rationale, not just procedures
- Posts SHOULD be written primarily for personal reference, with public benefit as secondary

## Configuration Management

### Version Control

- All site configuration MUST be committed to git
- Theme version MUST be explicitly specified in `_config.yml` (currently: `mmistakes/minimal-mistakes@4.19.3`)
- Changes to `_config.yml` MUST be documented in commit messages
- Generated site files (`_site/`) MUST remain excluded from version control
- Dependency versions MUST be locked in `Gemfile.lock`

### Jekyll Configuration

Required `_config.yml` settings:

- **Theme**: `remote_theme: mmistakes/minimal-mistakes@4.19.3`
- **Permalink format**: `/:year/:month/:day/:title/`
- **Timezone**: `Europe/London`
- **Locale**: `en-GB`
- **Pagination**: 10 posts per page at `/page:num/`
- **Markdown**: kramdown processor

Configuration changes MUST:
- Be tested locally before deployment
- Maintain backwards compatibility with existing content
- Not compromise static site principles
- Be documented in commit messages

Build warnings MUST be investigated and resolved before deployment.

## Local Development

### Prerequisites

- Docker Desktop

### Build Commands

**Local preview server**:
```bash
docker compose up
```
Site available at `http://localhost:4000`. LiveReload enabled.

**Rebuild image** (after Gemfile changes):
```bash
docker compose up --build
```

**Build static site only**:
```bash
docker compose run --rm jekyll bundle exec jekyll build
```
Output in `_site/` directory (excluded from git)

### Pre-commit Checklist

Before committing changes:
1. Site MUST build successfully with `docker compose up`
2. Build MUST complete without errors or warnings
3. All modified pages MUST render correctly in local preview at `http://localhost:4000`
4. Theme-related changes MUST be tested locally before committing

## Deployment and Testing

### Build Process

- Site MUST build successfully with `docker compose up`
- Build MUST complete without errors or warnings
- All pages MUST render correctly in local preview at `http://localhost:4000`
- Theme updates MUST be tested locally before committing

### Testing Steps

1. Run `docker compose up` locally
2. Verify build completes without errors or warnings
3. Review all modified pages in browser at `http://localhost:4000`
4. Check navigation, permalinks, and internal links
5. Verify responsive design on multiple screen sizes (if design changes made)
6. Commit and push to `master` for automatic deployment

### Deployment

- **Trigger**: Push to `master` branch
- **Platform**: GitHub Pages (automatic build and deployment)
- **URL**: https://www.andymadge.com
- **Build time**: Typically 1-3 minutes after push

Deployment rules:
- Breaking changes MUST be tested in a separate branch first
- Rollback plan MUST exist for any significant configuration changes
- Failed builds MUST be investigated and fixed immediately
- Build status SHOULD be monitored after deployment

## Governance

### Amendment Process

This constitution may be amended when project needs evolve. Amendments require:

1. Documentation of rationale for change
2. Version increment following semantic versioning
3. Update to this file with sync impact report (HTML comment at top)
4. Validation that dependent templates and documentation remain compatible
5. Update to README.md if constitutional changes affect documented procedures

### Compliance

- All changes to the site MUST align with these principles
- Violations MUST be explicitly justified and documented
- Complexity introduced MUST provide measurable value
- Regular reviews SHOULD verify adherence to these standards
- The constitution supersedes convenience - shortcuts that violate principles require amendment first

### Versioning Policy

Constitution follows semantic versioning:
- **MAJOR**: Backward-incompatible principle changes or removals
- **MINOR**: New principles or significantly expanded guidance
- **PATCH**: Clarifications, wording improvements, non-semantic refinements

### Documentation Consistency

- This constitution is the authoritative source for project governance
- README.md MUST reference this constitution for governance details
- Templates in `.specify/templates/` MUST align with constitutional principles
- Conflicts between documents MUST be resolved in favor of this constitution

**Version**: 1.0.1 | **Ratified**: 2025-11-25 | **Last Amended**: 2025-11-25
