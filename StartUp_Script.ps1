## Checks if its running as Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    ## Re-launch PowerShell as Admin
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Exit
}

## Output if program is running as Admin
Write-Host "Now Running with Administrator privileges!" -ForegroundColor Green

## Banner
$banner = "
 __        ___          _         _       ____            
 \ \      / (_)_ __    / \  _   _| |_ ___/ ___| _   _ ___ 
  \ \ /\ / /| | '_ \  / _ \| | | | __/ _ \___ \| | | / __|
   \ V  V / | | | | |/ ___ \ |_| | || (_) |__) | |_| \__ \
    \_/\_/  |_|_| |_/_/   \_\__,_|\__\___/____/ \__, |___/
                                                |___/     
"	

write-host "$banner"
write-Host ''
Write-Host 'Removing from Desktop Microsoft Edge' -ForegroundColor Green
write-Host ''

## Removes Microsoft Edge Icon from Dekstop
Get-ChildItem C:\Users\ | ForEach-Object {
    $desktopPath = "$($_.FullName)\Desktop\Microsoft Edge.lnk"
    if (Test-Path $desktopPath) {
        Remove-Item -Path $desktopPath -Force
    }
}

Write-Host ''

## Start installing Softwares
Write-Host 'Winget is updating and gonna start installing different softwares. This will take some time please be patient!!!' -ForegroundColor Green

Write-Host ''

winget source update

winget install -e --id Brave.Brave
winget install -e --id 7zip.7zip
winget install -e --id Notepad++.Notepad++
winget install -e --id MullvadVPN.MullvadVPN
winget install -e --id qBittorrent.qBittorrent
winget install -e --id Discord.Discord

Write-Host ''
Write-Host 'Softwares are Installed' -ForegroundColor Green
Write-Host ''

Write-Host 'Making RDP user "Only if user is Admin"' -ForegroundColor Green

## Checks if you are the admin Local account
$admUsr = [Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1]
if ($admUsr -eq "Admin") {

## User and Pass
$user = "RDPuser"
$pass = ConvertTo-SecureString "Gamerfrankstar1234" -AsPlainText -Force

## Creating the user
New-LocalUser -Name "$user" -Password $pass -FullName "$user" -Description "Remote Desktop Account"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "$user"

} else {
	Write-Host "You aren't the Admin user so no RDP Local user will be Created." -ForegroundColor Green
}

Write-Host "Everything is set." -ForegroundColor Green

Pause