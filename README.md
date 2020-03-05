# Import-ADFSWebTheme

This script contains the function "Import-ADFSWebTheme". It imports an ADFS WebTheme using the output from Exprot-ADFSWebtheme.

Run the script to load the function in an elevated PowerShell instance, then use the function by running: 

```powershell
Import-ADFSWebTheme -NewThemeName 'NewName' -Path 'c:\Temp\ADFSTheme' -Activate
```

## Parameters
### -NewThemeName
Imported theme will be added to avaiable themes on the server.

### -Path
Path of the folder containing an exported ADFSTheme, contents of this folder look like this:

![alt text](https://i.imgur.com/Elxij5P.png)

### -Activate
A switch that activates the imported theme. ADFS can hold multiple themes at once, so the theme that should be used by ADFS has to be activated. (Set-AdfsWebConfig -ActiveThemeName 'themename')