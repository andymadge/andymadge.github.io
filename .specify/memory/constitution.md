<!--
Sync Impact Report:
Version Change: Initial creation → 1.0.0
Modified Principles: N/A (initial version)
Added Sections: All sections (initial creation)
Removed Sections: None
Templates Status:
  ✅ .specify/templates/plan-template.md - reviewed, no updates needed (constitution check section exists)
  ✅ .specify/templates/spec-template.md - reviewed, no updates needed (compatible with content-focused requirements)
  ✅ .specify/templates/tasks-template.md - reviewed, no updates needed (flexible structure supports content and code tasks)
  ✅ .claude/commands/*.md - reviewed, no agent-specific references found
Follow-up TODOs: None
-->

# Andy Madge Personal Blog Constitution

## Core Principles

### I. Content-First Architecture

The primary purpose of this site is to publish and organize technical content. All features, configurations, and modifications must prioritize content accessibility, readability, and maintainability. Content should be stored in plain text formats (Markdown) that remain accessible independent of any specific platform or tool.

**Rationale**: A personal blog's value lies in its content, not its technical complexity. Content must remain portable and future-proof.

### II. Simplicity and Maintainability

Solutions MUST be simple, standard, and well-documented. Avoid custom code, complex configurations, or non-standard approaches when standard Jekyll/theme features exist. Every dependency and customization increases maintenance burden and MUST be justified.

**Rationale**: This is a personal project maintained by a single person with limited time. Complexity creates technical debt that diverts energy from content creation.

### III. Static Site Performance

The site MUST remain a static site built with Jekyll. No server-side processing, databases, or dynamic content generation should be introduced. All functionality should leverage GitHub Pages native capabilities and standard Jekyll plugins.

**Rationale**: Static sites provide security, performance, reliability, and zero-cost hosting through GitHub Pages. Dynamic features compromise these benefits.

### IV. Backwards Compatibility

Changes to theme configurations, permalinks, or site structure MUST maintain backwards compatibility with existing URLs and content. Existing blog posts MUST continue to work without modification unless explicitly required.

**Rationale**: External links, search engine indexing, and reader bookmarks depend on URL stability. Breaking changes damage discoverability and user trust.

### V. Minimal Dependencies

Dependencies (themes, plugins, gems) MUST be pinned to specific versions. New dependencies should only be added when they provide clear, substantial value that cannot be achieved with existing tools. Prefer Jekyll-native features over third-party plugins.

**Rationale**: Dependency updates can break builds unexpectedly. Version pinning ensures reproducible builds and controlled upgrades.

## Content Standards

### Content Organization

- Blog posts MUST be stored in `_posts/` following Jekyll's date-based naming convention: `YYYY-MM-DD-title.md`
- Draft posts MAY be stored in `_drafts/` without date prefixes
- Static pages MUST be stored in `_pages/` with appropriate front matter
- All content MUST use Markdown format with YAML front matter
- Images and assets MUST be stored in `assets/images/` with descriptive filenames

### Front Matter Requirements

Every post MUST include:
- `title`: Clear, descriptive post title
- `categories`: One or more relevant categories
- `tags`: Descriptive tags for discoverability

Posts MAY include:
- `header.image`: Path to header image for visual appeal
- `toc`: Boolean for table of contents generation
- Other theme-supported front matter fields as needed

### Content Quality

- Technical accuracy takes priority over publishing speed
- Code examples MUST be tested and functional
- External links SHOULD be checked periodically for validity
- Posts SHOULD include context and rationale, not just procedures

## Configuration Management

### Version Control

- All site configuration MUST be committed to git
- Theme version MUST be explicitly specified in `_config.yml`
- Changes to `_config.yml` MUST be documented in commit messages
- Generated site files (`_site/`) MUST remain excluded from version control

### Jekyll Configuration

- Theme: `mmistakes/minimal-mistakes` with explicit version pinning
- Plugins: Only GitHub Pages-compatible plugins may be used
- Configuration changes MUST be tested locally before deployment
- Build warnings MUST be investigated and resolved

## Deployment and Testing

### Build Process

- Site MUST build successfully with `bundle exec jekyll serve`
- Build MUST complete without errors or warnings
- All pages MUST render correctly in local preview before deployment
- Theme updates MUST be tested locally before committing

### Deployment

- Deployment occurs automatically via GitHub Pages on push to `master`
- Breaking changes MUST be tested in a separate branch first
- Rollback plan MUST exist for any significant configuration changes

## Governance

### Amendment Process

This constitution may be amended when project needs evolve. Amendments require:
1. Documentation of rationale for change
2. Version increment following semantic versioning
3. Update to this file with sync impact report
4. Validation that templates remain compatible

### Compliance

- All changes to the site MUST align with these principles
- Violations MUST be explicitly justified and documented
- Complexity introduced MUST provide measurable value
- Regular reviews SHOULD verify adherence to these standards

### Versioning Policy

Constitution follows semantic versioning:
- **MAJOR**: Backward-incompatible principle changes or removals
- **MINOR**: New principles or significantly expanded guidance
- **PATCH**: Clarifications, wording improvements, non-semantic changes

**Version**: 1.0.0 | **Ratified**: 2025-11-25 | **Last Amended**: 2025-11-25
