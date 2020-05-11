---
id: 41
title: Offline Files tips
date: 2007-06-28T11:09:33+00:00
author: AndyM
guid: http://blog.andymadge.com/uncategorized/2007/06/28/offline-files-tips/
categories:
  - Computers
  - Windows
---
### "Incorrect Function" Error

When synchronizing offline files, some files give an error:

> "Unable to make 'Filename.ext' available offline on \\Server\Share\Folder. Incorrect function."

Solution found [here](http://blogs.msdn.com/jonathanh/archive/2004/12/09/279292.aspx#439263)

  1. Open My Computer
  2. Goto Tools->Options
  3. Click on the Offline Files tab.
  4. Hold down CTRL+SHIFT and click DELETE FILES. This will completely clear the client cache and re-sync after a reboot.

### "Files of this type cannot be made available offline" Error

Error message:

> "Warnings occurred while Windows was synchronizing your data. Results: Offline files. Unable to make file name available offline. Files of this type cannot be made available offline."

To suppress error message for specific file types:

> <div class="indent">
>   [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache\ExclusionErrorSuppressionList]<br /> "*.pst"=dword:00000000<br /> "*.mdb"=dword:00000000<br /> "*.db?"=dword:00000000<br /> "*.ldb"=dword:00000000<br /> "*.mde"=dword:00000000<br /> "*.mdw"=dword:00000000<br /> "*.slm"=dword:00000000
> </div>

To change the error message display for all types: (from [here](http://support.microsoft.com/default.aspx?scid=kb;en-us;320139))  
To change this default behavior, use Registry Editor (Regedt32.exe) to locate the following key in the registry:

> <div class="indent">
>   [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Syncmgr]
> </div>
> 
> Add the following registry value:
> 
> <div class="indent">
>   Value Name: KeepProgressLevel<br /> Data Type: REG_DWORD<br /> Value: 1 (hexadecimal)
> </div>
> 
> You can add the following values and then quit Registry Editor:
> 
> <div class="indent">
>   1 - Pause on errors.<br /> 2 - Pause on warnings.<br /> 3 - Pause on errors and warnings.<br /> 4 - Pause and display INFO.
> </div>