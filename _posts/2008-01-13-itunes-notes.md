---
id: 47
title: iTunes Notes
date: 2008-01-13T01:56:47+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/uncategorized/2008/01/13/itunes-notes/
permalink: /2008/01/itunes-notes/
categories:
  - iTunes
---
Some notes on the way I use iTunes:

### Updating the Library

iTunes assumes that you will be allowing it to manage your music, and that the only ways you will add music are buying it from the iTunes Store, or ripping CDs with iTunes. It also assumes you will delete music from within iTunes. If you download music from other sources, or delete/move the files around in Explorer, then the iTunes library will lose track of the MP3s.<!--more-->

There are a number of ways around these problems, but the best I have found is a utility called <a href="http://itlu.ownz.ch/wordpress/" target="_blank" class="broken_link">iTunes Library Updater</a> This has both GUI and command-line versions, so it can be scheduled to run every day to keep the library up to date.

To schedule it, first of all create a profile with the settings you need and then save the profile. Add a Windows scheduled task with the command line:

> `iTLUConsole.exe /p:"c:\myprofile.itlu"`

### General Tips

If you have more than one computer, it is a good idea to set up the library so it uses UNC paths instead of local ones (e.g. `\\mycomputer\mp3s` ) Then you can copy the iTunes library database to any other computer and it will work. The easiest way to achieve this is through iTunes Library Updater &#8211; just make sure the paths you point it at are the UNC ones not the local ones. When it comes to copying the library to different PCs, I have a .BAT file on the main iTunes PC that I can run from any other PC &#8211; BringiTunes.bat:

> `copy "\\mainpc\c$\Documents and Settings\username\My Documents\My Music\iTunes\iTunes Music Library.xml" "%userprofile%\My Documents\My Music\iTunes\"`  
>  `copy "``\\mainpc\c$\Documents and Settings\username\My Documents\``My Music\iTunes\iTunes Library.itl" "%userprofile%\My Documents\My Music\iTunes\"`

Obviously you will need to change the `\\mainpc\c$\Documents and Settings\username\My Documents\` path to point to your iTunes folder.

### Ratings

#### 1 Star

Absolute rubbish. Every so often I go through and delete these.

#### 2 Stars

Stuff I don&#8217;t like and don&#8217;t ever want to listen to, but I don&#8217;t want to delete for some reason.

#### 3 Stars

Average tunes.

#### 4 Stars

Above average.

#### 5 Stars

Really, really good stuff. There aren&#8217;t many tunes that get this.

#### 0 Stars

Obvious really, but this is stuff I haven&#8217;t rated yet.

### Smart Playlists

Smart Playlists allow you to define all sorts of rules to organise your music, and then combine them to create very useful, auto updating playlists. They can be used as building blocks which you then combine into more complex playlists. Once you start creating smart playlists, you tend to find you use them a lot, so it&#8217;s worth using folders to organise them. I have the following folders:

  * Genres &#8211; pretty obvious, playlists containing one or more genres 
      * Indie &#8211; &#8220;genre is Indie OR genre is Alternative&#8221;
  * Artists &#8211; Playlists to list all music by an artist. 
      * Ian Brown &#8211; &#8220;artist is Ian Brown OR artist is Stone Roses&#8221;
  * Filters &#8211; Additional filters such as 
      * Don&#8217;t Play &#8211; &#8220;Rating is 1 or 2 stars&#8221;
      * Tracks 2 to 18 mins &#8211; &#8220;Length is between 2:00 and 18:00&#8243;. Filters out very short tracks and also mixes.
      * Top Rated &#8211; &#8220;Rating is at least 4 stars&#8221;
  * Andy iPod &#8211; playlists to synch with my iPod. 
      * Andy iPod All &#8211; this is a normal playlist (not a Smart one) and it contains everything I want synched to the iPod
      * iPod Smart Playlists &#8211; these combine the Smart Playlists on the PC with the playlist &#8220;Andy iPod All&#8221; which in effect creates iPod only versions of them. e.g. &#8220;iPod Top Rated&#8221; has the rules &#8220;Playlist is Top Rated and Playlist is Andy iPod All&#8221;

The playlists that I actually listen to are in the top level and not in folders. These are mostly built up by combining Filter and Genre playlists. e.g. almost every playlist here contains the rule &#8220;Playlist is not Don&#8217;t Play&#8221;

There&#8217;s a website with many different examples of Smart Playlists at <a href="http://www.smartplaylists.com/" target="_blank">http://www.smartplaylists.com/</a> Many of these go way beyond anything I would want to be doing, but there are lots of examples you can learn from.

### iPod Synching

If you set your iPod to automatic sync, and then tell it to only sync particular playlists, then you can manage the content of the iPod without plugging it in &#8211; next time you connect the iPod it will automatically update.

### Cover Art

Having Cover Art in your MP3s allows you to take advantage of the Cover Flow view in iTunes, and also on newer iPods.  
Since version 7 or so, iTunes has been able to automatically download any missing cover art for you automatically. This does require an iTunes account which is a bit annoying, but generally it works well and is a good way to fill in missing art. However, there is one major problem with this &#8211; it does not store the art in the actual MP3 file, it just stores it in the iTunes database. This may be fine if you are only ever going to use iTunes and only on 1 PC, but personally I use lots of other MP3 software that displays cover art &#8211; in particular Windows Media Center.

As a result, you&#8217;ve got to find another way of filling in the cover art. The best utilities I&#8217;ve found are:

  * <a href="http://www.ipodsoft.com/" target="_blank">iArt</a> &#8211; very good but not free (only $10 though) You can point it at a Playlist in iTunes and it will automatically get the cover art for each file.
  * <a href="http://album-cover-art-downloader.en.softonic.com/" target="_blank">Album Cover Art Downloader</a> &#8211; is free, although it&#8217;s a bit clunky and it does fall over sometimes. Still better than having to look for the cover art manually.

### Keeping Different Copies of iTunes Up To Date

I use iTunes in work as well as at home, and I listen to it more in work than at home, which means the ratings on my work PC are more up-to-date than the home ones. It&#8217;s a bit tricky to transfer ratings from one copy of iTunes to another, so I have written a utility to do it. This originally came from [here](http://www.hydrogenaudio.org/forums/index.php?showtopic=34668) but the only worked with US format dates (mm/dd/yyyy) so I re-wrote it to use ISO format dates (yyyy/mm/dd) and also added some extra features. It&#8217;s not quite working properly at the moment but I&#8217;ll put it up here a bit later.

### Video on iPods

If you use iTunes convert from an MPEG to and iPod video, sometimes you lose the audio. This is apparently a known problem. I haven&#8217;t found a solution yet, cos I don&#8217;t really watch video on the iPod.

### Other Utilities

  * <a href="http://www.mp3tag.de/en/" target="_blank">Mp3tag</a> &#8211; Excellent MP3 tag editor. Simple to use, but also has incredibly powerful scripting features if you want to use them.