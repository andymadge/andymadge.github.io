---
id: 128
title: Missing tooltips in Firefox 3.5 and IE8
guid: http://andymadge.com/blog/?p=128
header:
  image: assets/images/header-images/IMG_3054_w2500.jpeg
categories:
  - Computers
tags:
  - software
---
I've just upgraded to Firefox 3.5 and noticed that tooltips had stopped working.  I then checked Internet Explorer 8 and found tooltips were not working there either.

On investigation it seems that the two problems were unrelated, but here are the solutions to both of them...<!--more-->

### Firefox 3.5

It seems there's a bug in the Google Toolbar which can stop tooltips from working (you just get a small square instead). The fix is to uninstall Google Toolbar, then re-install it.

### Internet Explorer 8

Bizarrely, this isn't a bug.  It's a rare occasion when IE does the right thing according to the W3C spec.  Basically, the HTML "alt" attribute has long been used to display tooltips over images, where in fact, it's only supposed to be shown if the image doesn't load.  The correct attribute for displaying tooltips is actually the "title" attribute.  Internet Explorer 8 has changed so that it works correctly according to the HTML spec.

What this means is that if a web page has only alt tags then in IE8 normal mode, you won't see any tooltips.  If however the page is in IE8 compatibility mode, you _will_ see the tooltips.