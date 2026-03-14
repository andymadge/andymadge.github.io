# Quickstart: Disqus Comments on DJ Mix Posts

## What changes

| File | Change |
|------|--------|
| `_config.yml` | `comments: false` → `comments: true` for `_djmixes` scope (line 141) |
| `_includes/mix-download.html` | Add "Comment on this mix" anchor link |

## How to verify locally

Disqus only renders in production (`jekyll.environment == "production"`), so you cannot test the full Disqus embed locally. You can verify:

1. **"Comment on this mix" link appears**: Run `bundle exec jekyll serve` and open any mix page — the link should appear next to (or instead of) "Download mix".
2. **Link is absent when comments disabled**: Add `comments: false` to a test mix's front matter — the link should disappear.
3. **Full Disqus embed**: Deploy to GitHub Pages (`git push origin 003-disqus-djmix`, open a preview, or merge to `master`) and visit a mix page to confirm the Disqus thread renders.

## Build command

```bash
bundle exec jekyll serve --livereload
```

Visit `http://localhost:4000` → navigate to any DJ mix page.
