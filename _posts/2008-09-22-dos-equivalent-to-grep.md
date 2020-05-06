---
id: 64
title: DOS Equivalent of GREP
date: 2008-09-22T14:40:18+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/uncategorized/2008/09/22/dos-equivalent-to-grep/
categories:
  - Computers
  - Windows
---
In Unix you can pipe the output of a command into the GREP command in order to only display the lines that contain a required string.  This is means you don&#8217;t have to scroll through pages of output to find the bit you&#8217;re interested in.  The DOS equivalent of GREP is FIND:

<pre>Searches for a text string in a file or files.

FIND [/V] [/C] [/N] [/I] [/OFF[LINE]] "string" [[drive:][path]filename[ ...]]

/V         Displays all lines NOT containing the specified string.
/C         Displays only the count of lines containing the string.
/N         Displays line numbers with the displayed lines.
/I         Ignores the case of characters when searching for the string.
/OFF[LINE] Do not skip files with offline attribute set.
"string"   Specifies the text string to find.
[drive:][path]filename
Specifies a file or files to search.

<em>If a path is not specified, FIND searches the text typed at the prompt
or piped from another command.</em></pre>

this can be useful with the netstat command:

<pre>netstat -ano | find /i ":80"</pre>

or when viewing the DNS cache:

<pre>ipconfig /displaydns | find /i "google"</pre>

Although that isn&#8217;t ideal since the output of ipconfig isn&#8217;t really formatted to play nicely with the find command.

Reference: <http://nzpcmad.blogspot.com/2007/07/dos-grep-equivalent-find-command.html>