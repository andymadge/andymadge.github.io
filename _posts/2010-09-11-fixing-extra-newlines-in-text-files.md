---
id: 193
title: Fixing Extra Newlines in Text Files
guid: http://www.andymadge.com/?p=193
toc: true
categories:
  - Programming
---
When editing source code you often come across files with additional blank lines that shouldn't be there.

![Extra blank lines]({% link /assets/images/fixing-newlines-01.png %})

The problem is generally caused by someone editing the file with a text editor which doesn't understand and maintain the different newline types. You then end up with a file containing a mix of different line endings.

<!--more-->

Mixed line endings can have all sorts of unexpected consequences in your applications. Also, editing is really annoying since you have to do a lot more scrolling.

The common newline types are:

<table>
  <tr>
    <td>LF</td>
    <td>Unix, Linux and Mac OS X</td>
  </tr>
  
  <tr>
    <td>CR</td>
    <td>Mac OS up to 9</td>
  </tr>
  
  <tr>
    <td>CR+LF</td>
    <td>Windows</td>
  </tr>
</table>

There's more info in [Wikipedia](http://en.wikipedia.org/wiki/Newline).

## Removing the Additional Lines

The solution is to to use search and replace to get rid of the extra lines, and then convert all the line ending in the file to the same type.

First you need a text editor that can display the different types and also search for each of them separately. I recommend [Notepad2](http://www.flos-freeware.ch/notepad2.html) since it's very good and also free.

If you open the file in Notepad2 then go to View -> "Show Line Endings" you'll see the line endings:

![Mixed line endings]({% link /assets/images/fixing-newlines-02.png %})

Now that you know which line endings are in the file, you can bring up the Replace dialog:

![Replace dialog]({% link /assets/images/fixing-newlines-03.png %})

To search for the line endings, you need to tick "Transform backslahes"

Then search for the corresponding line end type:

<table>
  <tr>
    <td>\r</td>
    <td>CR</td>
  </tr>
  
  <tr>
    <td>\n</td>
    <td>LF</td>
  </tr>
  
  <tr>
    <td>\r\n</td>
    <td>CR+LF</td>
  </tr>
</table>

In this example I'm going to search for all the CR+LF and replace them with nothing. Hit "Replace All" and your file is magically back to normal.

The only thing left to do is convert all the line endings to the correct type. Go to File -> "Line Endings" and chose whichever type you need (do this even if it's already selected)

You have now got a file with consistent line endings and no extraneous blank lines:

![Finished result]({% link /assets/images/fixing-newlines-04.png %})

## Alternative Method

An alternative method is to convert the newlines first and then swap all the double newlines for singles.

After converting the line endings you get:

![Alternate - extra blank lines]({% link /assets/images/fixing-newlines-05.png %})

Next do the following Replace:

![Alternate - replace dialog]({% link /assets/images/fixing-newlines-06.png %})

Now you should have the same result as above.