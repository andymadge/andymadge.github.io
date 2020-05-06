---
id: 193
title: Fixing Extra Newlines in Text Files
date: 2010-09-11T18:56:16+00:00
author: AndyM
layout: post
guid: http://www.andymadge.com/?p=193
categories:
  - Programming
---
When editing source code you often come across files with additional blank lines that shouldn&#8217;t be there.

<img class="size-full wp-image-196" title="Extra blank lines" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-17_31_28.png" alt="Extra blank lines" width="629" height="501" /> 

The problem is generally caused by someone editing the file with a text editor which doesn&#8217;t understand and maintain the different newline types. You then end up with a file containing a mix of different line endings.<!--more-->

Mixed line endings can have all sorts of unexpected consequences in your applications. Also, editing is really annoying since you have to do a lot more scrolling.

The common newline types are:

<table border="0">
  <tr>
    <td>
      LF
    </td>
    
    <td>
      Unix, Linux and Mac OS X
    </td>
  </tr>
  
  <tr>
    <td>
      CR
    </td>
    
    <td>
      Mac OS up to 9
    </td>
  </tr>
  
  <tr>
    <td>
      CR+LF
    </td>
    
    <td>
      Windows
    </td>
  </tr>
</table>

There&#8217;s more info in [Wikipedia](http://en.wikipedia.org/wiki/Newline).

## Removing the Additional Lines

The solution is to to use search and replace to get rid of the extra lines, and then convert all the line ending in the file to the same type.

First you need a text editor that can display the different types and also search for each of them separately. I recommend [Notepad2](http://www.flos-freeware.ch/notepad2.html) since it&#8217;s very good and also free.

If you open the file in Notepad2 then go to View &#8211;> &#8220;Show Line Endings&#8221; you&#8217;ll see the line endings:

<img class="size-full wp-image-194" title="Mixed line ending" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-17_27_59.png" alt="Mixed line ending" width="648" height="466" /> 

Now that you know which line endings are in the file, you can bring up the Replace dialog:

<img class="size-full wp-image-206" title="Replace dialog" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-17_54_08.png" alt="Replace dialog" width="515" height="305" />  
To search for the line endings, you need to tick &#8220;Transform backslahes&#8221;

Then search for the corresponding line end type:

<table border="0">
  <tr>
    <td>
      \r
    </td>
    
    <td>
      CR
    </td>
  </tr>
  
  <tr>
    <td>
      \n
    </td>
    
    <td>
      LF
    </td>
  </tr>
  
  <tr>
    <td>
      \r\n
    </td>
    
    <td>
      CR+LF
    </td>
  </tr>
</table>

In this example I&#8217;m going to search for all the CR+LF and replace them with nothing. Hit &#8220;Replace All&#8221; and your file is magically back to normal.

The only thing left to do is convert all the line endings to the correct type. Go to File &#8211;> &#8220;Line Endings&#8221; and chose whichever type you need (do this even if it&#8217;s already selected)

You have now got a file with consistent line endings and no extraneous blank lines:

<img class="alignnone size-full wp-image-208" title="Screenshot - 11_09_2010 , 18_03_38" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-18_03_38.png" alt="Screenshot - 11_09_2010 , 18_03_38" width="629" height="501" /> 

## Alternative Method

An alternative method is to convert the newlines first and then swap all the double newlines for singles.

After converting the line endings you get:

<img class="alignnone size-full wp-image-210" title="Screenshot - 11_09_2010 , 18_07_54" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-18_07_54.png" alt="Screenshot - 11_09_2010 , 18_07_54" width="629" height="501" /> 

Next do the following Replace:

<img class="alignnone size-full wp-image-211" title="Screenshot - 11_09_2010 , 18_09_46" src="http://www.andymadge.com/blog/wp-content/uploads/Screenshot-11_09_2010-18_09_46.png" alt="Screenshot - 11_09_2010 , 18_09_46" width="515" height="305" /> 

Now you should have the same result as above.