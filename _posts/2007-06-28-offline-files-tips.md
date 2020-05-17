---
id: 41
title: Offline Files tips
date: 2007-06-28T11:09:33+00:00
guid: http://blog.andymadge.com/uncategorized/2007/06/28/offline-files-tips/
categories:
  - Computers
tags:
  - windows
---
### "Incorrect Function" Error

When synchronizing offline files, some files give an error:

> "Unable to make `Filename.ext` available offline on `\\Server\Share\Folder`. Incorrect function."

Solution found [here](http://blogs.msdn.com/jonathanh/archive/2004/12/09/279292.aspx#439263)

  1. Open My Computer
  2. Goto Tools->Options
  3. Click on the Offline Files tab.
  4. Hold down CTRL+SHIFT and click DELETE FILES. This will completely clear the client cache and re-sync after a reboot.

### "Files of this type cannot be made available offline" Error

Error message:

> "Warnings occurred while Windows was synchronizing your data. Results: Offline files. Unable to make file name available offline. Files of this type cannot be made available offline."

To suppress error message for specific file types:

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\NetCache\ExclusionErrorSuppressionList]
    "*.pst"=dword:00000000
    "*.mdb"=dword:00000000
    "*.db?"=dword:00000000
    "*.ldb"=dword:00000000
    "*.mde"=dword:00000000
    "*.mdw"=dword:00000000
    "*.slm"=dword:00000000
```

To change the error message display for all types: (from [here](http://support.microsoft.com/default.aspx?scid=kb;en-us;320139))  

To change this default behavior, use Registry Editor (Regedt32.exe) to locate the following key in the registry:

```
[HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Syncmgr]
```

Add the following registry value:

```
Value Name: KeepProgressLevel
Data Type: REG_DWORD
Value: 1 (hexadecimal)
```


You can add the following values and then quit Registry Editor:

```
1 - Pause on errors.
2 - Pause on warnings.
3 - Pause on errors and warnings.
4 - Pause and display INFO.
```
