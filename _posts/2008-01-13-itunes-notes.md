---
id: 47
title: iTunes Notes
guid: http://blog.andymadge.com/uncategorized/2008/01/13/itunes-notes/
header:
  image: assets/images/header-images/IMG_6898_w2500.jpeg
toc: true
categories:
  - Computers
tags:
  - itunes
---
Some notes on the way I use iTunes:

### Updating the Library

iTunes assumes that you will be allowing it to manage your music, and that the only ways you will add music are buying it from the iTunes Store, or ripping CDs with iTunes. It also assumes you will delete music from within iTunes. If you download music from other sources, or delete/move the files around in Explorer, then the iTunes library will lose track of the MP3s.

<!--more-->

There are a number of ways around these problems, but the best I have found is a utility called [iTunes Library Updater](http://itlu.ownz.ch/wordpress/) This has both GUI and command-line versions, so it can be scheduled to run every day to keep the library up to date.

To schedule it, first of all create a profile with the settings you need and then save the profile. Add a Windows scheduled task with the command line:

```batchfile
iTLUConsole.exe /p:"c:\myprofile.itlu"
```

### General Tips

If you have more than one computer, it is a good idea to set up the library so it uses UNC paths instead of local ones (e.g. `\\mycomputer\mp3s` ) Then you can copy the iTunes library database to any other computer and it will work. The easiest way to achieve this is through iTunes Library Updater - just make sure the paths you point it at are the UNC ones not the local ones. When it comes to copying the library to different PCs, I have a .BAT file on the main iTunes PC that I can run from any other PC - `BringiTunes.bat`:

```batchfile
copy "\\mainpc\c$\Documents and Settings\username\My Documents\My Music\iTunes\iTunes Music Library.xml" "%userprofile%\My Documents\My Music\iTunes\"  
copy "\\mainpc\c$\Documents and Settings\username\My Documents\My Music\iTunes\iTunes Library.itl" "%userprofile%\My Documents\My Music\iTunes\"
```

Obviously you will need to change the `\\mainpc\c$\Documents and Settings\username\My Documents\` path to point to your iTunes folder.

### Ratings

#### 1 Star

Absolute rubbish. Every so often I go through and delete these.

#### 2 Stars

Stuff I don't like and don't ever want to listen to, but I don't want to delete for some reason.

#### 3 Stars

Average tunes.

#### 4 Stars

Above average.

#### 5 Stars

Really, really good stuff. There aren't many tunes that get this.

#### 0 Stars

Obvious really, but this is stuff I haven't rated yet.

### Smart Playlists

Smart Playlists allow you to define all sorts of rules to organise your music, and then combine them to create very useful, auto updating playlists. They can be used as building blocks which you then combine into more complex playlists. Once you start creating smart playlists, you tend to find you use them a lot, so it's worth using folders to organise them. I have the following folders:

  * Genres - pretty obvious, playlists containing one or more genres 
      * Indie - "genre is Indie OR genre is Alternative"
  * Artists - Playlists to list all music by an artist. 
      * Ian Brown - "artist is Ian Brown OR artist is Stone Roses"
  * Filters - Additional filters such as 
      * Don't Play - "Rating is 1 or 2 stars"
      * Tracks 2 to 18 mins - "Length is between 2:00 and 18:00". Filters out very short tracks and also mixes.
      * Top Rated - "Rating is at least 4 stars"
  * Andy iPod - playlists to synch with my iPod. 
      * Andy iPod All - this is a normal playlist (not a Smart one) and it contains everything I want synched to the iPod
      * iPod Smart Playlists - these combine the Smart Playlists on the PC with the playlist "Andy iPod All" which in effect creates iPod only versions of them. e.g. "iPod Top Rated" has the rules "Playlist is Top Rated and Playlist is Andy iPod All"

The playlists that I actually listen to are in the top level and not in folders. These are mostly built up by combining Filter and Genre playlists. e.g. almost every playlist here contains the rule "Playlist is not Don't Play"

There's a website with many different examples of Smart Playlists at <a href="http://www.smartplaylists.com/" target="_blank">http://www.smartplaylists.com/</a> Many of these go way beyond anything I would want to be doing, but there are lots of examples you can learn from.

### iPod Synching

If you set your iPod to automatic sync, and then tell it to only sync particular playlists, then you can manage the content of the iPod without plugging it in - next time you connect the iPod it will automatically update.

### Cover Art

Having Cover Art in your MP3s allows you to take advantage of the Cover Flow view in iTunes, and also on newer iPods.  
Since version 7 or so, iTunes has been able to automatically download any missing cover art for you automatically. This does require an iTunes account which is a bit annoying, but generally it works well and is a good way to fill in missing art. However, there is one major problem with this - it does not store the art in the actual MP3 file, it just stores it in the iTunes database. This may be fine if you are only ever going to use iTunes and only on 1 PC, but personally I use lots of other MP3 software that displays cover art - in particular Windows Media Center.

As a result, you've got to find another way of filling in the cover art. The best utilities I've found are:

  * <a href="http://www.ipodsoft.com/" target="_blank">iArt</a> - very good but not free (only $10 though) You can point it at a Playlist in iTunes and it will automatically get the cover art for each file.
  * <a href="http://album-cover-art-downloader.en.softonic.com/" target="_blank">Album Cover Art Downloader</a> - is free, although it's a bit clunky and it does fall over sometimes. Still better than having to look for the cover art manually.

### Keeping Different Copies of iTunes Up To Date

I use iTunes in work as well as at home, and I listen to it more in work than at home, which means the ratings on my work PC are more up-to-date than the home ones. It's a bit tricky to transfer ratings from one copy of iTunes to another, so I have written a utility to do it. This originally came from [here](http://www.hydrogenaudio.org/forums/index.php?showtopic=34668) but the only worked with US format dates (mm/dd/yyyy) so I re-wrote it to use ISO format dates (yyyy/mm/dd) and also added some extra features. It's not quite working properly at the moment but I'll put it up here a bit later.

### Video on iPods

If you use iTunes convert from an MPEG to and iPod video, sometimes you lose the audio. This is apparently a known problem. I haven't found a solution yet, cos I don't really watch video on the iPod.

### Other Utilities

  * <a href="http://www.mp3tag.de/en/" target="_blank">Mp3tag</a> - Excellent MP3 tag editor. Simple to use, but also has incredibly powerful scripting features if you want to use them.