# Research: Disqus Comments on DJ Mix Posts

**Feature**: 003-disqus-djmix | **Date**: 2026-03-14

All research findings are documented inline in [plan.md](plan.md) under the Phase 0 Decision Log (D-001 through D-004). No external research was required — all answers were derived from the existing codebase.

## Summary

| ID | Question | Decision |
|----|----------|----------|
| D-001 | How does Minimal Mistakes render Disqus? | Via `single` layout when `comments != false` and provider configured |
| D-002 | Scroll target for "Comment on this mix" | `href="#disqus_thread"` — standard anchor, no JS needed |
| D-003 | When to show "Comment on this mix" link | When `page.comments != false` |
| D-004 | Link placement | Inside existing `<p class="mix-download">` in `mix-download.html` |
