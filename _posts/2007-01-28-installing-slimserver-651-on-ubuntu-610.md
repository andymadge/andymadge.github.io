---
id: 32
title: Installing SlimServer 6.5.1 on Ubuntu 6.10
date: 2007-01-28T23:56:05+00:00
guid: http://blog.andymadge.com/ubuntu/2007/01/28/installing-slimserver-651-on-ubuntu-610/
categories:
  - Computers
tags:
  - ubuntu
  - linux
---
Ubuntu is based on Debian, so I followed the instructions on the Slim Devices website [here](http://wiki.slimdevices.com/index.php/Debian_Package) and it worked fine. It basically involves adding the Slim Devices repository to Synaptic Package Manager `Settings/Repository -> Third Party` and then installing using apt-get.

The next thing to do is mount the network share so it can be accessed by SlimServer.