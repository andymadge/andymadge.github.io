---
id: 128
title: Missing tooltips in Firefox 3.5 and IE8
date: 2009-07-05T23:24:37+00:00
author: AndyM
layout: post
guid: http://andymadge.com/blog/?p=128
categories:
  - Computers
---
I&#8217;ve just upgraded to Firefox 3.5 and noticed that tooltips had stopped working.  I then checked Internet Explorer 8 and found tooltips were not working there either.

On investigation it seems that the two problems were unrelated, but here are the solutions to both of them&#8230;<!--more-->

### Firefox 3.5

It seems there&#8217;s a bug in the Google Toolbar which can stop tooltips from working (you just get a small square instead). The fix is to uninstall Google Toolbar, then re-install it.

### Internet Explorer 8

Bizarrely, this isn&#8217;t a bug.  It&#8217;s a rare occasion when IE does the right thing according to the W3C spec.  Basically, the HTML &#8220;alt&#8221; attribute has long been used to display tooltips over images, where in fact, it&#8217;s only supposed to be shown if the image doesn&#8217;t load.  The correct attribute for displaying tooltips is actually the &#8220;title&#8221; attribute.  Internet Explorer 8 has changed so that it works correctly according to the HTML spec.

What this means is that if a web page has only alt tags then in IE8 normal mode, you won&#8217;t see any tooltips.  If however the page is in IE8 compatibility mode, you _will_ see the tooltips.