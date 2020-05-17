---
id: 30
title: 'First time Ubuntu experiences...'
guid: http://blog.andymadge.com/linux/ubuntu/2007/01/28/ubuntu-experiences/
categories:
  - Computers
tags:
  - ubuntu
  - linux
---
![Ubuntu logo]({% link assets/images/Ubuntu_Logo.png %})

I've just installed [Ubuntu](http://www.ubuntu.com/) 6.10 and I'm going to be recording my experiences here, mostly so I can refer back to it later when I can't remember how I did things...  
<!--more-->

  
The computer I'm installing it on is an old Compaq Celeron 850 with 256MB RAM, a 60GB HDD and a Nvidia FX5200 graphics card. It is currently running Windows XP and is connected to the TV and hi-fi in my lounge for watching movies and browsing the web. I also want to run SlimServer - It's current running on my main desktop PC and it's a bit slow.

I've tried the Ubuntu 6.10 LiveCD and it seems to support most of the hardware including the wireless network card. Performance is a bit sluggish but I hope this is down to the fact that it's running in 256MB RAM without a swap file.

The installation from the LiveCD is very easy and I managed to get it installed without problems. I was a bit worried about the partitioning, but it resized the old Windows XP partition and installed Grub on the MBR.

It now seems to be running quite well - it's much more responsive than the LiveCD was and the dual boot with Windows XP is working properly.

My current todo list is:

  * [Mount the Windows partition automatically at boot]({% post_url 2007-01-28-auto-mounting-ntfs-partitions-at-boot %})
  * Install newest Nvidia driver and configure TV out
  * [Install SlimServer]({% post_url 2007-01-28-installing-slimserver-651-on-ubuntu-610 %})
  * Mount MP3 network share from main Windows PC - this is where all the music for SlimServer is stored.
  * Install multimedia software - DivX etc.