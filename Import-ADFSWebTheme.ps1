#Requires -RunAsAdministrator
function Import-ADFSWebTheme {
    <#
    .SYNOPSIS
    Imports an ADFS webtheme using the output from cmdlet Export-ADFSWebTheme 
    .DESCRIPTION
    Imports a new web theme to an ADFS server, using the export from Export-ADFSWebTheme , and can active the new theme.
    Importing a theme adds it to the available themes. to see all avaiable themes: Get-ADFSWebTheme
    This function is only tested with basic themes.
    .EXAMPLE
    Import-ADFSWebTheme -NewThemeName NewName -Path 'c:\Temp\ADFSTheme'
    .EXAMPLE
    Import-ADFSWebTheme -NewThemeName NewName -Path 'c:\Temp\ADFSTheme' -Activate
    .PARAMETER NewName
    Optional parameter specify an OrgId, default it will take the first OrgId retrieved from Get-MrkOrganizations
    .PARAMETER Path
    File path containing the exported files. Typically it points to the directory containing subdirectories: "illustration","logo","css" .
    .PARAMETER Activate
    Sets the imported web theme as active
    #>
    [cmdletbinding()]
    Param(
        [Parameter()][String]$NewThemeName,
        [Parameter()][String]$Path,
        [switch]$Activate
    )
    #Script prerequisites
    if (!(Get-Module -ListAvailable ADFS)){
        Write-Host Import-ADFSWebTheme: ADFS module not found on this machine`, Aborting.. 
        break    
    }
    if (Get-ADFSWebTheme -Name $NewThemeName){
        Write-Host Import-ADFSWebTheme: ADFS theme $NewThemeName already found on this server, aborting.. 
        break    
    }
    if (!(Test-path $Path)){
        Write-Host Import-ADFSWebTheme: Path not found $Path, aborting.. 
        break    
    }
    $ThemeDir = Get-Item $Path 
    #New-AdfsWebTheme arguments are splatted
    $Arguments = @{}
    $Arguments.Add('Name',$NewThemeName)

    If (Test-Path "$ThemeDir\illustration\illustration.*"){
        $illustrationItem = Get-Item "$ThemeDir\illustration\illustration.*"
        $illustrationHT = @{Locale="";Path=$illustrationItem.FullName}
        $Arguments.Add('Illustration',$illustrationHT)
    }

    #-AdditionalFileResource @{Uri="/adfs/portal/Background.png";Path="C:\Background.png"} 
    #never found a theme with a background pic, so i dont know the location it can be found in a backup. 

    If (Test-Path "$ThemeDir\logo\logo.*"){
        $logoItem = Get-Item "$ThemeDir\logo\logo.*"
        $logoHT=@{Locale="";Path=$logoItem.FullName}
        $Arguments.Add('Logo',$logoHT)
    }
    If (Test-Path "$ThemeDir\css\style.rtl.css"){ 
        $stylertlcss = Get-Item "$ThemeDir\css\style.rtl.css"
        $Arguments.Add('RTLStyleSheetPath',$stylertlcss.FullName)
    }
    If (Test-Path "$ThemeDir\css\style.css"){ 
        $stylecss = Get-Item "$ThemeDir\css\style.css"
        $stylecssHT = @{Locale="";Path=$stylecss.FullName}
        $Arguments.Add('StyleSheet',$stylecssHT)
    }
    #create new Theme
    New-AdfsWebTheme @Arguments | Out-Null

    if ($Activate){
        Set-AdfsWebConfig -ActiveThemeName $NewThemeName
    } Else {
        Write-Host Theme $NewThemeName succesfully imported. To activate the theme use: Set-AdfsWebConfig `-ActiveThemeName $NewThemeName
    }
}