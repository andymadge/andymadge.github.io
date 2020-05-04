---
id: 345
title: Installing additional Ubuntu software
date: 2009-03-09T09:26:13+00:00
author: AndyM
layout: revision
guid: http://www.andymadge.com/2009/03/36-revision-2/
permalink: /2009/03/36-revision-2/
---
To install additional software required to support various types of multimedia:

#### The GUI way

  1. Applications->Add/Remove Applications.
  2. Type `xine` into the search box at the top.
  3. Find &#8220;Xine extra plugins&#8221; in the list and tick it.
  4. Find and select &#8220;Gstreamer extra codec&#8221; and &#8220;Sun Java 5.0 Plugin&#8221;
  5. Press OK.

#### The Command Line way

This is much quicker as long as you know the names of the packages you want to install.

  1. Install codecs etc: 
    <pre>sudo apt-get install sox vorbis-tools flac lame mpg321 faad faac</pre>

  2. Install the Xine-backend version of Totem: 
    <pre>sudo apt-get install totem-xine</pre>

#### Flash v9

The version of Flash in Ubuntu 6.10 is v7 which is quite old. Lots of websites now require version 9, which is easy to install in Firefox:

  1. Go to <http://www.adobe.com/products/flash/about/>
  2. Click on the green jigsaw piece icon to install the current version of Flash.