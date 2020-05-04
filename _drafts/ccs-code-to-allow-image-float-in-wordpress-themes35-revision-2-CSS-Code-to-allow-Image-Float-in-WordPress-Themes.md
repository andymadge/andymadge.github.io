---
id: 346
title: CSS Code to allow Image Float in WordPress Themes
date: 2009-03-09T09:26:13+00:00
author: AndyM
layout: revision
guid: http://www.andymadge.com/2009/03/35-revision-2/
permalink: /2009/03/35-revision-2/
---
To enable the ability to float images left or right, add the following code to the CSS stylesheet.

Obviously this works for any web page, I just happen to be doing it for this blog on WordPress.

<!--more-->

<pre>pre, code {
font-size: 1.2em;
}

pre {
width: 100%;
overflow: auto;
border: 1px solid #e5e5e5;
padding: 5px;
}

img.right {
padding: 4px;
margin: 0 0 2px 7px;
/*    display: inline; */
}

img.left {
padding: 4px;
margin: 0 7px 2px 0;
/*    display: inline; */
}

img.centered {
display: block;
margin-left: auto;
margin-right: auto;
}

.right { float: right; }
.left { float: left; }</pre>