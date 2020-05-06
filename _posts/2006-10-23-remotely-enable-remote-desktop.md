---
id: 23
title: Remotely Enable Remote Desktop
date: 2006-10-23T20:58:51+00:00
author: AndyM
layout: post
guid: http://blog.andymadge.com/pc-help/2006/10/23/remotely-enable-remote-desktop/
categories:
  - Computers
---
Instructions How to do it&#8230;

<!--more-->from 

[here](http://www.petri.co.il/remotely_enable_remote_desktop_on_windows_server_2003.htm):

> <font size="5">How can I remotely enable</font> <font size="5" face="Verdana">Remote Desktop on Windows Server 2003?</font>
> 
> <p style="margin-right: 30px">
>   <font size="2" face="Verdana">With Remote Desktop on Windows XP Professional or Windows Server 2003 (in Windows 2000 Advanced Server, this feature was called Terminal Services in Remote Administration Mode), you can have access to a Windows session that is running on your computer when you are at another computer. </font>
> </p>
> 
> <font size="2">What you need to do is create the new RDP listening port via the registry:</font>
> 
>   1. <font size="2">Run REGEDIT on your XP workstation or on your Windows 2000/2003 Server. </font>
>   2. <font size="2">Click on File, then choose &#8220;Connect Network Registry&#8221;.</font>
> 
> >  										[ 										<font size="2"><img width="100" height="71" border="1" src="http://www.petri.co.il/images/enable_rdp_remotely_small.gif" /></font>](http://www.petri.co.il/images/enable_rdp_remotely.gif){.broken_link}
> 
> <ol start="3">
>   <li>
>     <font size="2">In the Select Computer search box either browse Active Directory to locate the remote server, or type its name in the dialog box.</font>
>   </li>
> </ol>
> 
> >  									[ 									<font size="2"><img width="100" height="52" border="1" src="http://www.petri.co.il/images/enable_rdp_remotely1_small.gif" /></font>](http://www.petri.co.il/images/enable_rdp_remotely1.gif){.broken_link}
> > 
> > <font size="2">Click Ok.</font>
> 
> <ol start="5">
>   <li value="4">
>     <font size="2">In the remote machine&#8217;s registry browse to the following key:</font>
>   </li>
> </ol>
> 
> >  									<font face="Verdana"><textarea cols="50" name="S4" rows="3">HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server</textarea></font>