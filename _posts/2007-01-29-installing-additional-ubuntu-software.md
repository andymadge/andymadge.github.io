---
id: 36
title: Installing additional Ubuntu software
date: 2007-01-29T22:25:35+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/computers/2007/01/29/installing-additional-ubuntu-software/
categories:
  - Computers
  - Ubuntu Linux
---
To install additional software required to support various types of multimedia:

#### The GUI way

  1. Applications->Add/Remove Applications.
  2. Type `xine` into the search box at the top.
  3. Find "Xine extra plugins" in the list and tick it.
  4. Find and select "Gstreamer extra codec" and "Sun Java 5.0 Plugin"
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