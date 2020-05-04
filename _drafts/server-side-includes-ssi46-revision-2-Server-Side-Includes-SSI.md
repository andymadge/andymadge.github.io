---
id: 337
title: Server Side Includes (SSI)
date: 2009-03-09T09:26:13+00:00
author: AndyM
layout: revision
guid: http://www.andymadge.com/2009/03/46-revision-2/
permalink: /2009/03/46-revision-2/
---
Server Side Include can be used to allow insertion of an HTML into another. e.g. header or footer can be separated from pages so you only have to change a single file to update the header/footer on all pages of your site.<!--more-->

[Here](http://www.andreas.com/faq-ssi.html)&#8216;s a fairly good introduction to SSI although it does miss a few important points:

  * If you are using .htaccess to enable SSI for a single folder you may want to add couple of extra lines:  
    `Options Indexes FollowSymLinks Includes<br />
AddType application/x-httpd-cgi .cgi<br />
AddType text/x-server-parsed-html .html`
  * A better option is to use the XBitHack: 
      1. Remove from .htaccess anything else relating to SSI
      2. add `XBitHack on`
      3. set the HTML file (i.e. the one containing the include statement) to be executable (e.g. `chmod +x pagename.html`)