---
id: 64
title: DOS Equivalent of GREP
guid: http://blog.andymadge.com/uncategorized/2008/09/22/dos-equivalent-to-grep/
header:
  image: assets/images/header-images/IMG_8437_w2500.jpeg
categories:
  - Computers
tags:
  - windows
---
In Unix you can pipe the output of a command into the GREP command in order to only display the lines that contain a required string.  This is means you don't have to scroll through pages of output to find the bit you're interested in.  The DOS equivalent of GREP is FIND:

```
Searches for a text string in a file or files.

FIND [/V] [/C] [/N] [/I] [/OFF[LINE]] "string" [[drive:][path]filename[ ...]]

/V         Displays all lines NOT containing the specified string.
/C         Displays only the count of lines containing the string.
/N         Displays line numbers with the displayed lines.
/I         Ignores the case of characters when searching for the string.
/OFF[LINE] Do not skip files with offline attribute set.
"string"   Specifies the text string to find.
[drive:][path]filename
Specifies a file or files to search.

If a path is not specified, FIND searches the text typed at the prompt
or piped from another command.
```

this can be useful with the netstat command:

```batchfile
netstat -ano | find /i ":80"
```

or when viewing the DNS cache:

```batchfile
ipconfig /displaydns | find /i "google"
```

Although that isn't ideal since the output of ipconfig isn't really formatted to play nicely with the find command.

Reference: <http://nzpcmad.blogspot.com/2007/07/dos-grep-equivalent-find-command.html>