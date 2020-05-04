---
id: 31
title: Auto Mounting NTFS partitions at boot
date: 2007-01-28T23:53:48+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/uncategorized/2007/01/28/ubuntu-continued/
permalink: /2007/01/auto-mounting-ntfs-partitions-at-boot/
categories:
  - Ubuntu Linux
---
There&#8217;s a very useful Getting Started document over at [UbuntuGuide](http://ubuntuguide.org/wiki/Ubuntu_Edgy) which describes lots of basic configuration tasks.

In the Ubuntu 6.10 official documentation there seem to be references to a utility in System->Administration->Disks but apparently the Disks utility was removed in v6.10. It&#8217;s not difficult to edit the /etc/fstab file as on any other Linux. There are instructions in the Ubuntu documentation and also [here](http://ubuntuguide.org/wiki/Ubuntu_Edgy#How_to_mount_Windows_partitions_.28NTFS.29_on_boot-up.2C_and_allow_all_users_to_read_only)

<!--more-->

> #### How to mount Windows partitions (NTFS) on boot-up, and allow all users to read only
> 
>   * Read [#General Notes](http://ubuntuguide.org/wiki/Ubuntu_Edgy#General_Notes)
>   * Read [#How to list partition tables](http://ubuntuguide.org/wiki/Ubuntu_Edgy#How_to_list_partition_tables)
> 
> :   _e.g. Assumed that /dev/hda1 is the location of Windows partition (NTFS)_ 
> :      _Local mount folder: /media/windows_ 
> 
> <pre>sudo mkdir /media/windows
sudo cp /etc/fstab /etc/fstab_backup
gksudo gedit /etc/fstab</pre>
> 
>   * Append the following line at the end of file
> 
> <pre>/dev/hda1    /media/windows ntfs  nls=utf8,umask=0222 0    0</pre>
> 
>   * Save the edited file
>   * Read [#How to remount /etc/fstab without rebooting](http://ubuntuguide.org/wiki/Ubuntu_Edgy#How_to_remount_.2Fetc.2Ffstab_without_rebooting)

To remount without rebooting, type:

<pre>sudo mount -a</pre>