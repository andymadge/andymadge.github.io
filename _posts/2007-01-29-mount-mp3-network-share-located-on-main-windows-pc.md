---
id: 33
title: Mount MP3 network share located on main Windows PC
date: 2007-01-29T12:26:38+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/ubuntu/2007/01/29/mount-mp3-network-share-located-on-main-windows-pc/
categories:
  - Ubuntu Linux
---
SlimServer doesn't like the Music Folder path in the form `smb://computer/share` - presumably it can't use smbclient. I therefore need to mount this share in the filesystem.

Parts of this are taken from [here](http://ubuntuforums.org/showthread.php?t=280473) and [here](http://www.mattvanstone.com/2006/06/automatically_mounting_smb_sha.html){.broken_link}.

<!--more-->

  1. Install smbfs: 
    <pre>sudo apt-get install smbfs</pre>

  2. Create a folder in the /media folder: 
    <pre>sudo mkdir /media/mp3</pre>

  3. Mount the share manually to test it: 
    <pre>sudo smbmount //computer/MP3 /media/mp3 -o username=USER,password=PASSWORD,uid=1000,mask=000</pre>
    
    Note: Change USER to your linux username. The `uid=USER,gid=users` is important because if you dont use that, only root will have access to write files to the mounted share.</li> 
    
      * Unmount it: 
        <pre>sudo smbumount /media/mp3</pre>
    
      * Add an entry to `/etc/fstab` so it is mounted on boot: 
        <pre>sudo gedit /etc/fstab</pre>
        
        and add this line at the bottom:
        
        <pre>//computer/MP3 /media/mp3   smbfs  auto,credentials=/home/USER/.credentials,uid=1000,umask=000,user   0 0</pre>
    
      * Create the `.smbcredentials` file in the user's home directory: 
        <pre>sudo gedit ~/.smbcredentials</pre>
        
        Add the following lines to the file, but change USER to your SMB username and PASSWORD to your SMB password.
        
        <pre>username=USER
password=PASSWORD</pre>
    
      * Reload fstab:
    <pre>sudo mount -a</pre></ol> 
    
    NOTE: you could have included the username and password in the fstab but this way is more secure.
    
    NOTE: Do not try and mount a folder on a share, it wont work. The source for an SMB mount has to be a share.
    
    NOTE: Do not put a trailing "/" on the share path or the directory path, it will cause it to fail.
    
    ### SMB Shares with spaces in the names
    
    If you have an SMB share with a space in the path then replace the space with "`\040`" (This only applies to the entry in `/etc/fstab`, from the command line you can just enclose the share path in quotes)