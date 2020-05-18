---
id: 55
title: 'Online &amp; Peer-To-Peer Backup'
guid: http://blog.andymadge.com/computers/2008/06/20/online-peer-to-peer-backup/
header:
  image: assets/images/header-images/IMG_6913_w2500.jpeg
toc: true
categories:
  - Computers
tags:
  - software
---
I've been assessing various backup options for both business and personal use recently so here's a summary of my findings

<!--more-->

The problem with any form of local backup such as CD/DVD or external hard drive is that it only protects you from a hard drive crash. If someone steals your computer or your house burns down, it's likely that you'll lose the backup as well.

Off-site backups avoid these risks although there are disadvantages - if you are doing it manually you have to remember to do it and to take the backup off site (e.g. store the CDRs/external drive at work or a friends house)

Online backups are automatic and are stored off-site, but the disadvantage is that backups and restores take a very long time. They can also be very expensive.

The final option is Peer-To-Peer (p2p) backup. This is similar to traditional online backup but instead of your data being stored at some company's datacentre, it is stored on a friend's PC. Most people have massive hard drives these days so setting aside some for a friend's backup is not a problem.

Anyway, my findings...

## Online Backup

Most of these are expensive - into the 10s of dollars per month once you go above 5GB storage, however if you look around there are some very well priced unlimited services.

### [Carbonite](http://www.carbonite.com/)

Price: _Free 15 day trial / $49.95 per year Unlimited Storage_

This seems to receive good reviews and the install and configuration was simple enough. Some reviews mentioned problems restoring and also that tech support wasn't brilliant. They also have an Acceptable Usage Policy so it's not really unlimited. I decided against this one.

### [Mozy](https://mozy.com/?ref=M7HBYL)

Price: _FREE limited version / $54.45 per year Unlimited Storage_

Lots of positive reviews although some criticism of the UI being too simple. Personally I like it and it allows some powerful filtering. Tech support seems to be good, although I've had no contact myself. Explicitly states in the FAQ that there are no limits on number of files, file size, or total space usage. Free account gives you 2GB storage, although you get 0.25GB extra for everyone who you refer. It's possible to get files sent to you on DVD although this is expensive and only available in the USA. Think I'm going to use Mozy for my online backup

## Peer-To-Peer Backup (P2P)

There are plenty of P2P file sharing applications out there which allow you to synchronise a folder on your PC with one on a friend's PC, however, by definition these allow your friend to read your files. A proper backup system will encrypt you files so your friend has no idea what data you are backing up to their PC.

### [FolderShare](http://www.foldershare.com/){.broken_link}

Price: _FREE_ 

I've been using this for a few years and it works very well, however it is just a file sharing system. I mention it because it's great for backing up something like your MP3 collection where you don't mind your friend having access. You can make the shared files read only so your friend can't change them. One problem with FolderShare is that it doesn't cope very well with removable storage, so libraries on external drives can be a bit sketchy.

### [BuddyBackup](http://www.buddybackup.com/)

Price: _Free limited version, £10 for full version (one-off fee)  
_ 

On first impression this seems good, but I then had problems with it crashing, and didn't receive any reply from tech support. Has lots of potential but doesn't seem to be under active development.

### [LogMeIn Backup](https://secure.logmein.com/products/backup/)

Price: <span style="font-style: italic">$39.95 /year per PC</span>

Haven't tried this. I have tried some of their other services so based on those I expect this to be excellent.

### [CrashPlan](http://www.crashplan.com/)

Price: <span style="font-style: italic">Free 30 day trial / $20 </span><em style="font-style: italic">(one-off fee) </em><span style="font-style: italic">for Standard version / $60 </span><span style="font-style: italic"><em style="font-style: italic">(one-off fee) </em><span style="font-style: italic">for Pro version</span></span>

This seems excellent and it looks like the one I'm going with. Reasonably simple to configure although it did require port forwarding [Release Notes](http://www.crashplan.com/support/releases.vtl){.broken_link} show the project is currently very active and they seem to respond to user comments. Another bonus is that CrashPlan works on Windows, Mac and Linux (soon) and each can backup to the other.

Useful features that are apparently [coming soon](http://www.crashplan.com/support/support.vtl):

  * Local backup to USB drive and later continuing differentially over the WAN
  * Local restore from a USB drive that was once remote

## Conclusion

At the moment it looks like I'm going to end up with a combination of Mozy, FolderShare and CrashPlan. This will cost about £55 for first year and £28 a year after that. Seems good value to me. There is actually a hidden cost though - the hard drive space required to hold friends' backups. That said, I just bought a 500GB drive for £60, so it's not too expensive