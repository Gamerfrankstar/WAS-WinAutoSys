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

Write-Host ''

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
$discWeb = "https://discord.com/api/webhooks/1297616163697590422/LR-fL-KEhPSpWElIa9kwHt6bifVY9ZHzYIDH-k_im5YrOQTxOu2AO7DBWgHG9VhbLmD2"
$discEmbed = @{
    title = "Virtual Machine is ready to connect to"
    description = "
    Device Public IPv4 Address: **$PubIP**
    Device local IPV4 Address : **$LocalIP**
    User: **$User**
    Password: **$Pass**"
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
