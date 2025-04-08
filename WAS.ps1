function StandardInstall {
    clear-host
        
            $PubIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
            $LocalIP = (
            Get-NetIPConfiguration |
            Where-Object {
            $_.IPv4DefaultGateway -ne $null -and
            $_.NetAdapter.Status -ne "Disconnected"
            }
        ).IPv4Address.IPAddress

        $banner = "
 __        ___          _         _       ____            
 \ \      / (_)_ __    / \  _   _| |_ ___/ ___| _   _ ___ 
  \ \ /\ / /| | '_ \  / _ \| | | | __/ _ \___ \| | | / __|
   \ V  V / | | | | |/ ___ \ |_| | || (_) |__) | |_| \__ \
    \_/\_/  |_|_| |_/_/   \_\__,_|\__\___/____/ \__, |___/
                                                |___/     
"	

        write-host "$banner" -ForegroundColor Cyan
        Write-Host "Standard Installation"
        write-Host ''
        Write-Host 'Removing from Desktop Microsoft Edge' -ForegroundColor Green
        write-Host ''

        Get-ChildItem C:\Users\ | ForEach-Object {
        $desktopPath = "$($_.FullName)\Desktop\Microsoft Edge.lnk"
        if (Test-Path $desktopPath) {
        Remove-Item -Path $desktopPath -Force
        }
    }

        Write-Host ''

        Write-Host 'Winget is updating and gonna start installing different softwares. This will take some time please be patient!!!' -ForegroundColor Green

        winget install -e --id Brave.Brave
        winget install -e --id MullvadVPN.MullvadVPN
        winget install -e --id qBittorrent.qBittorrent
        winget install -e --id 7zip.7zip
        winget install -e --id Microsoft.VisualStudioCode
        winget install -e --id Discord.Discord

        Write-Host ''
        Write-Host 'Softwares are Installed' -ForegroundColor Green
        Write-Host ''

        Write-Host "Do you want to create a RDP User?"
        $rdpmk = read-host ("Y/N") 

        if($rdpmk -ieq "Y"){ 
            Write-Host 'Making RDP user' -ForegroundColor Green
   
            $User = read-host "What Username?"
            $Pass = ConvertTo-SecureString read-host "What Password?" -AsPlainText -Force

            New-LocalUser -Name "$User" -Password $Pass -FullName "$User" -Description "Remote Desktop Account"
            Add-LocalGroupMember -Group "Remote Desktop Users" -Member "$User"
        }
       
        elseif($rdpmk -ieq "N"){
            Write-host "No RDP User will be made"
        }

        else {
            Write-host "No proper input given so will be skipped."
        }
        
        $discpayout = read-Host "Do you want to send to a Discord Webhook? (Y/N)"

        if ($discpayout -ieq "Y"){
        $dischook = read-host "Insert Webhook link"

        $discWeb = "$dischook"
        $discEmbed = @{
        title = "Virtual Machine is ready to connect."
        description = "
    Device Public IPv4 Address: **$PubIP**
    Device local IPV4 Address : **$LocalIP**
    User: **$User**
    Password: **$Pass** 
    "
        color = 5814783  
        }
        $discMessage = @{
        username = "VM BOT"
        embeds = @($discEmbed)
        }

        $jsonMessage = $discMessage | ConvertTo-Json -Depth 4
        Invoke-RestMethod -Uri $discWeb -Method Post -Body $jsonMessage -ContentType "application/json"
        }
        elseif ($discpayout -ieq "N") {
        write-host "No payload will not be sendt to discord"
        }

        else{
        Write-host "No input has been give and no discord output will be given"
        }
        
        elseif ($rdpmk -ieq "N") {
            Write-Host "No RDP user will be made"
        }

    Write-Host "Everything is set." -ForegroundColor Green


}

function advancedinstall {
    clear-host
    
        $PubIP = (Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
        $LocalIP = (
        Get-NetIPConfiguration |
        Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
        }
    ).IPv4Address.IPAddress

    $banner = "
__        ___          _         _       ____            
\ \      / (_)_ __    / \  _   _| |_ ___/ ___| _   _ ___ 
 \ \ /\ / /| | '_ \  / _ \| | | | __/ _ \___ \| | | / __|
  \ V  V / | | | | |/ ___ \ |_| | || (_) |__) | |_| \__ \
   \_/\_/  |_|_| |_/_/   \_\__,_|\__\___/____/ \__, |___/
                                            |___/     
"	

    write-host "$banner" -ForegroundColor Cyan
    Write-Host "Advanced Installation"
    write-Host ''
    Write-Host 'Removing from Desktop Microsoft Edge' -ForegroundColor Green
    write-Host ''


    Get-ChildItem C:\Users\ | ForEach-Object {
    $desktopPath = "$($_.FullName)\Desktop\Microsoft Edge.lnk"
    if (Test-Path $desktopPath) {
    Remove-Item -Path $desktopPath -Force
    }
}

    Write-Host ''

    Write-Host 'Software installation Selections menu' -ForegroundColor Green
    softwareinstallmenu
    
    Write-Host ''

    $rdpmk = read-host "Do you want to create a RDP User? (Y/N)"
    
    if($rdpmk -ieq "Y"){ 
        Write-Host 'Making RDP user' -ForegroundColor Green

        $User = read-host "What Username?"
        $Pass = ConvertTo-SecureString read-host "What Password?" -AsPlainText -Force

        New-LocalUser -Name "$User" -Password $Pass -FullName "$User" -Description "Remote Desktop Account"
        Add-LocalGroupMember -Group "Remote Desktop Users" -Member "$User"
    }
   
    elseif($rdpmk -ieq "N"){
        Write-host "No RDP User will be made"
    }

    else {
        Write-host "No proper input given so will be skipped."
    }

    $discpayout = read-host "Do you want to send to a Discord Webhook? (Y/N)"

    if ($discpayout -ieq "Y"){
    $dischook = read-host "Insert Webhook link"

    $discWeb = "$dischook"
    $discEmbed = @{
    title = "Virtual Machine is ready to connect."
    description = "
Device Public IPv4 Address: **$PubIP**
Device local IPV4 Address : **$LocalIP**
User: **$User**
Password: **$Pass** 
"
    color = 5814783 
    }
    $discMessage = @{
    username = "VM BOT"
    embeds = @($discEmbed)
    }

    $jsonMessage = $discMessage | ConvertTo-Json -Depth 4
    Invoke-RestMethod -Uri $discWeb -Method Post -Body $jsonMessage -ContentType "application/json"
    }
    elseif ($discpayout -ieq "N") {
    write-host "No payload will not be sendt to discord"
    }

    else{
    Write-host "No input has been give and no discord output will be given"
    }
    
    elseif ($rdpmk -ieq "N") {
        Write-Host "No RDP user will be made"
    }

Write-Host "Everything is set." -ForegroundColor Green
Pause
}

function softwareinstallmenu {
write-host "
Browsers:
Chrome
Brave
Opera
Tor
Firefox
Librewolf"

$Selectbrowser = read-host "What browser? (Default selection Brave)"
if ($Selectbrowser -ieq "Brave") {
    $Selectbrowser = "Brave.brave"
    $selectedbrowser = "Brave"
} elseif ($Selectbrowser -ieq "Chrome") {
    $Selectbrowser = "Google.Chrome"
    $selectedbrowser = "Chrome"
} elseif ($Selectbrowser -ieq "Opera") {
    $Selectbrowser = "Opera.Opera"
    $selectedbrowser = "Opera"
} elseif ($Selectbrowser -ieq "Tor") {
    $Selectbrowser = "Torproject.torbrowser"
    $selectedbrowser = "Tor Browser"
} elseif ($Selectbrowser -ieq "Firefox") {
    $Selectbrowser = "Mozilla.Firefox"
    $selectedbrowser = "Firefox"
} elseif ($Selectbrowser -ieq "Librewolf") {
    $Selectbrowser = "Librewolf.Librewolf"
    $selectedbrowser = "Librewolf"
} else {
    $Selectbrowser = "Brave.Brave"
    $selectedbrowser = "Default"
}

write-host "$selectedbrowser has been selected" -ForegroundColor Green

Write-host "
VPN: 
Expressvpn
Mullvad
NordVPN
Fortinet
IPVanish
Proton"

$Selectvpn = read-host "What VPN? (Default selection: Mullvad)"
if ($Selectvpn -ieq "Expressvpn") {
    $Selectvpn = "ExpressVPN.ExpressVPN"
    $selectedvpn = "ExpressVPN"
} elseif ($Selectvpn -ieq "Mullvad") {
    $Selectvpn = "MullvadVPN.MullvadVPN"
    $selectedvpn = "Mullvad"
} elseif ($Selectvpn -ieq "NordVPN") {
    $Selectvpn = "NordSecurity.NordVPN"
    $selectedvpn = "NordVPN"
} elseif ($Selectvpn -ieq "Fortinet") {
    $Selectvpn = "Fortinet.FortiClientVPN"
    $selectedvpn = "FortinetVPN"
} elseif ($Selectvpn -ieq "IPvanish") {
    $Selectvpn = "IPVanish.IPVanish"
    $selectedvpn = "IPVanish"
} elseif ($Selectvpn -ieq "Proton") {
    $Selectvpn = "Proton.ProtonVPN"
    $selectedvpn = "ProtonVPN"
} else {
    $Selectvpn = "MullvadVPN.MullvadVPN"
    $selectedvpn = "Default"
}

Write-Host "$selectedvpn has been selected" -ForegroundColor Green

write-host "
Torrents:
qBitTorrent
BitTorrent 
uTorrent"

$selectTorrent = Read-Host "What Torrent? (Default selection: qBitTorrent)"
if ($selectTorrent -ieq "qBitTorrent") {
    $selectTorrent = "qBittorrent.qBittorrent"
    $selectedTorrent = "qBitTorrent"
} elseif ($selectTorrent -ieq "Bittorrent") {
    $selectTorrent = "BitTorrent.BitTorrent"
    $selectedTorrent = "BitTorrent"
} elseif ($selectTorrent -ieq "uTorrent") {
    $selectTorrent = "BitTorrent.uTorrent"
    $selectedTorrent = "uTorrent"
} else {
    $selectTorrent = "qBittorrent.qBittorrent"
    $selectedTorrent = "Default"
}

write-host "$selectedTorrent has been selected" -ForegroundColor Green

Write-Host "
File Archievers:
7Zip
WinRAR
WinZip"

$selectfile = Read-Host "What File Archiever? (Default Selection: 7Zip)"
if ($selectfile -ieq "7Zip") {
    $selectfile = "7zip.7zip"
    $selectedfile = "7Zip"
} elseif ($selectfile -ieq "WinRAR") {
    $selectfile = "RARLab.WinRAR"
    $selectedfile = "WinRAR"
} elseif ($selectfile -ieq "WinZIP") {
    $selectfile = "Corel.WinZip"
    $selectedfile = "WinZIP"
} else {
    $selectfile = "7zip.7zip"
    $selectedfile = "Default"
}

Write-Host "$selectedfile has been selected" -ForegroundColor Green

Write-host "
Text Editor:
Notepad++
VS-Code
Vim"

$selecttext = Read-Host "What Text Editor? (Default Selection: Notepad++)"
if ($selecttext -ieq "Notepad++") {
    $selecttext = "Notepad++.Notepad++"
    $selectedtext = "Notepad++"
} elseif ($selecttext -ieq "VS-Code") {
    $selecttext = "Microsoft.VisualStudioCode"
    $selectedtext = "Visual Studio Code"
} elseif ($selecttext -ieq "Vim") {
    $selecttext = "Vim.Vim"
    $selectedtext = "VIM"
} else {
    $selecttext = "Notepad++.Notepad++"
    $selectedtext = "Default"
}

Write-Host "$selectedtext has been selected" -ForegroundColor Green

winget install -e --id $selectbrowser 
winget install -e --id $selectfile
winget install -e --id $selecttext
winget install -e --id $selectvpn
winget install -e --id $selectTorrent

$discinstall = Read-host "Do you want to install Discord? (Y/N)"
if ($discinstall -ieq "Y") {
    winget install -e -id Discord.Discord
} elseif ($discinstall -ieq "N") {
    Write-Host "Discord won't get installed" -ForegroundColor Red
} else {
    Write-Host "No Proper input so Discord won't be installed" -ForegroundColor Red
}

Write-Host "Software installation is complete!" -ForegroundColor Green
}

function nobloat{
    $banner = "
__        ___          _         _       ____            
\ \      / (_)_ __    / \  _   _| |_ ___/ ___| _   _ ___ 
 \ \ /\ / /| | '_ \  / _ \| | | | __/ _ \___ \| | | / __|
  \ V  V / | | | | |/ ___ \ |_| | || (_) |__) | |_| \__ \
   \_/\_/  |_|_| |_/_/   \_\__,_|\__\___/____/ \__, |___/
                                            |___/     
"	
    Clear-Host
    write-host "$banner" -ForegroundColor Cyan
    Write-Host "De-Bloating Windows"
    write-Host ''

    Get-AppxPackage *Recall* | Remove-AppxPackage
    Write-Host "Uninstalled Recall" -ForegroundColor Green

    Get-AppxPackage *Teams* | Remove-AppxPackage
    Write-Host "Uninstalled Teams" -ForegroundColor Green

    Get-AppxPackage *Cortana* | Remove-AppxPackage
    Write-Host "Uninstalled Cortana" -ForegroundColor Green

    Get-AppxPackage *office* | Remove-AppxPackage
    Write-Host "Uninstalled Office365" -ForegroundColor Green

    Get-AppxPackage *clipchamp* | Remove-AppxPackage
    Write-Host "Uninstalled clipchamp" -ForegroundColor Green

    C:\Windows\system32\OneDriveSetup.exe /uninstall
    Write-Host "Uninstalled Onedrive" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Todos* | Remove-AppxPackage
    Write-Host "Uninstalled ToDo" -ForegroundColor Green

    Get-AppxPackage *Microsoft.OutlookForWindows* | Remove-AppxPackage
    Write-Host "Uninstalled Outlook" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Windows.DevHome* | Remove-AppxPackage
    Write-Host "Uninstalled DevHome" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage
    Write-Host "Uninstalled StickyNote" -ForegroundColor Green

    Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage
    Write-Host "Uninstalled Get Help" -ForegroundColor Green

    Get-AppxPackage *Microsoft.GamingApp* | Remove-AppxPackage
    Write-Host "Uninstalled Gamingapp" -ForegroundColor Green

    Get-AppxPackage *3DViewer* | Remove-AppxPackage
    Write-Host "Uninstalled 3DViewer" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Copilot* | Remove-AppxPackage
    Write-Host "Uninstalled Copilot" -ForegroundColor Green

    Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage
    Write-Host "Uninstalled Feedback Hub" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Windows.Input.* | Remove-AppxPackage
    Write-Host "Uninstalled Handwriting" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MIP* | Remove-AppxPackage
    Write-Host "Uninstalled Math Input Panel" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MixedReality* | Remove-AppxPackage
    Write-Host "Uninstalled Mixed Reality" -ForegroundColor Green

    Get-AppxPackage *Microsoft.People* | Remove-AppxPackage
    Write-Host "Uninstalled People" -ForegroundColor Green

    Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage
    Write-Host "Uninstalled Skype" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage
    Write-Host "Uninstalled Solitaire" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Windows.ScreenSketch* | Remove-AppxPackage
    Write-Host "Uninstalled Step Recorder" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Wallet* | Remove-AppxPackage
    Write-Host "Uninstalled Wallet" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Bing* | Remove-AppxPackage
    Write-Host "Uninstalled Bing Search" -ForegroundColor Green

    Get-AppxPackage *Microsoft.WindowsFamilySafety* | Remove-AppxPackage
    Write-Host "Uninstalled Family" -ForegroundColor Green

    Get-AppxPackage *Microsoft.OneSync* | Remove-AppxPackage
    Write-Host "Uninstalled OneSync" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MSPaint* | Remove-AppxPackage
    Write-Host "Uninstalled Paint 3D" -ForegroundColor Green

    Get-AppxPackage *Microsoft.MicrosoftQuickAssist* | Remove-AppxPackage
    Write-Host "Uninstalled Quick Assist" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Speech* | Remove-AppxPackage
    Write-Host "Uninstalled Speech" -ForegroundColor Green

    Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage
    Write-Host "Uninstalled Tips" -ForegroundColor Green

    Get-AppxPackage *Microsoft.WindowsVoiceRecorder* | Remove-AppxPackage
    Write-Host "Uninstalled Voice Recorder" -ForegroundColor Green

    Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage
    Write-Host "Uninstalled Weather" -ForegroundColor Green

    Get-AppxPackage *Microsoft.WindowsHello* | Remove-AppxPackage
    Write-Host "Uninstalled Windows Hello" -ForegroundColor Green

    Get-AppxPackage *Microsoft.Wordpad* | Remove-AppxPackage
    Write-Host "Uninstalled Wordpad" -ForegroundColor Green

    Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage
    Write-Host "Uninstalled Your Phone" -ForegroundColor Green

    Write-host "Wait a min and let everything run"
    Pause
}

function Adminrun {
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    
    if ($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "                  Running with Administrator" -ForegroundColor Green
    }
    else {
        Write-Host "                Running without Administrator" -ForegroundColor Red
    }
}

function Show-Menu{
    $Title = "__          ___                     _        _____           
\ \        / (_)         /\        | |      / ____|          
 \ \  /\  / / _ _ __    /  \  _   _| |_ ___| (___  _   _ ___ 
  \ \/  \/ / | | '_ \  / /\ \| | | | __/ _ \\___ \| | | / __|
   \  /\  /  | | | | |/ ____ \ |_| | || (_) |___) | |_| \__ \
    \/  \/   |_|_| |_/_/    \_\__,_|\__\___/_____/ \__, |___/
                                                    __/ |    
                                                   |___/     "
    Clear-Host
    Write-Host "$Title" -ForegroundColor Cyan
    Write-Host ""
    Adminrun
    Write-Host "=================== Made By Gamerfrankstar ===================="-ForegroundColor DarkGreen
    Write-Host ""
    Write-Host "                  1: Standard Installation"
    Write-Host "                  2: Advanced Installation"
    Write-Host "                  3: De-Bloater "
    Write-Host "                  X: To Quit the program"
    Write-Host ""
    Write-host "===============================================================" -ForegroundColor DarkGreen
}

function Process-MenuChoice {
    param (
        [string]$Versionselect
    )
    switch ($Versionselect) {
        "1" { StandardInstall }
        "2" { advancedinstall }
        "3" { nobloat }
        "X" {  }
        default { Write-Host "Invalid option, please try again." }
    }
}

do {
    Show-Menu
    $Versionselect = Read-Host "Please select an option (1-3)"
    Process-MenuChoice $Versionselect
} while ($Versionselect -ne "X")
