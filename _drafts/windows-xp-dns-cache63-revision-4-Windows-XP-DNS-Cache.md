---
id: 325
title: Windows XP DNS Cache
date: 2014-03-13T00:19:03+00:00
author: AndyM
layout: revision
guid: http://www.andymadge.com/2014/03/63-revision-4/
permalink: /2014/03/63-revision-4/
---
Windows caches DNS responses to speed up network access, but sometimes this can cause a problem.  Positive responses (i.e. successful lookups) are cached for 24 hours, and negative responses (i.e. failed lookups) for 5 minutes.

If you make changes to DNS and want to test the results straight away, you need to clear the cache with:

<pre>ipconfig /flushdns</pre>

You can view the current cache with:

<pre>ipconfig /displaydns</pre>

or

<pre>ipconfig /displaydns | more</pre>

to see a screen at a time