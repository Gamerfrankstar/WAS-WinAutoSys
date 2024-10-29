## Software Selector
$BrowserSelect = 1 ## 1 = Chrome 2 = FireFox 3 = Brave 4 =Tor Browser 5 = LibreWolf 6 = Opera. 
$VPNSelect = 1 ## 1 = ExpressVPN 2 = MullVad VPN 3 = NordVPN 4 = Fortinet VPN 5 = IPvanish 6 = ProtonVPN
$TorrentSelect = 1 ## 1 = qBittorrent 2 = BitTorrent 3 = uTorrent
$FileSelect = 1 ## 1 = 7Zip 2 = WinRAR 3 = Winzip
$textSelect = 1 ## 1 = Notepad++ 2 = VS Code 3 = Vim ;)

## Getting IPV4 Addresses.
$PubIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
$LocalIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress

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

## Browser Selected
if ($BrowserSelect -eq 1) {
    $SelectedBrowse = "Google.Chrome"
} elseif ($BrowserSelect -eq 2) {
    $SelectedBrowse = "Mozilla.Firefox"
} elseif ($BrowserSelect -eq 3) {
    $SelectedBrowse = "Brave.Brave"
} elseif ($BrowserSelect -eq 4) {
    $SelectedBrowse = "TorProject.TorBrowser"
} elseif ($BrowserSelect -eq 5) {
    $SelectedBrowse = "LibreWolf.LibreWolf"
} elseif ($BrowserSelect -eq 6) {
    $SelectedBrowse = "Opera.Opera"
} else {
    Write-Host ""
}

## VPN Selected
if ($VPNSelect -eq 1) {
    $SelectedVPN = "ExpressVPN.ExpressVPN"
} elseif ($VPNSelect -eq 2) {
    $SelectedVPN = "MullvadVPN.MullvadVPN"
} elseif ($VPNSelect -eq 3) {
    $SelectedVPN = "NordSecurity.NordVPN"
} elseif ($VPNSelect -eq 4) {
    $SelectedVPN = "Fortinet.FortiClientVPN"
} elseif ($VPNSelect -eq 5) {
    $SelectedVPN = "IPVanish.IPVanish"
} elseif ($VPNSelect -eq 6) {
    $SelectedVPN = "Proton.ProtonVPN"
} else {
    Write-Host ""
} 
Write-Host ''

## Torrent Selected
if ($TorrentSelect -eq 1) {
    $SelectedTorrent = "qBittorrent.qBittorrent"
} elseif ($TorrentSelect -eq 2) {
    $SelectedTorrent = "BitTorrent.BitTorrent"
} elseif ($TorrentSelect -eq 3) {
    $SelectedTorrent = "BitTorrent.uTorrent"
} else {
    Write-Host ""
}

## Achiever Selected
if ($FileSelect -eq 1){
    $SelectedFile = "7zip.7zip"
} elseif ($FileSelect -eq 2) {
    $SelectedFile = "RARLab.WinRAR"
} elseif ($FileSelect -eq 3) {
    $SelectedFile = "Corel.WinZip"
} else {
    Write-Host ""
}

## Text Editor Selected
if ($textSelect -eq 1){
    $SelectedText = "Notepad++.Notepad++"
} elseif ($textSelect -eq 2) {
    $SelectedText = "Microsoft.VisualStudioCode"
} elseif ($textSelect -eq 3) {
    $SelectedText = "Vim.Vim"
} else {
    Write-Host ""
}

winget install -e --id $SelectedBrowse
winget install -e --id $SelectedFile
winget install -e --id $SelectedText
winget install -e --id $SelectedVPN
winget install -e --id $SelectedTorrent
winget install -e --id Discord.Discord

Write-Host ''
Write-Host 'Softwares are Installed' -ForegroundColor Green
Write-Host ''

Write-Host 'Making RDP user "Only if user is Admin"' -ForegroundColor Green

## Checks if you are the admin Local account
$admUsr = [Security.Principal.WindowsIdentity]::GetCurrent().Name.Split('\')[-1]
if ($admUsr -eq "Admin") {

## Setup User.
$User = "RDPuser"
$Pass = ConvertTo-SecureString "pass1234" -AsPlainText -Force

## Creating the user
New-LocalUser -Name "$User" -Password $Pass -FullName "$User" -Description "Remote Desktop Account"
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "$User"

} else {
	Write-Host "You aren't the Admin user so no RDP Local user will be Created." -ForegroundColor Green
}

## Outputs the message to Discord
$discWeb = "Insert Webhook link"
$discEmbed = @{
    title = "Virtual Machine is ready to connect."
    description = "
    Device Public IPv4 Address: **$PubIP**
    Device local IPV4 Address : **$LocalIP**
    User: **$User**
    Password: **$Pass** 
    "
    color = 5814783  ## For Custom Colors
}

## Bot Name
$discMessage = @{
    username = "VM BOT"
    embeds = @($discEmbed)
}

## Webhook Payload
$jsonMessage = $discMessage | ConvertTo-Json -Depth 4
Invoke-RestMethod -Uri $discWeb -Method Post -Body $jsonMessage -ContentType "application/json"

Write-Host "Everything is set." -ForegroundColor Green

Pause
