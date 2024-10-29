# WAS-WinAutoSys
Simple Windows poweshell script that'll run with custom ISO images

## This is a simple script made for easy deployment of Windows 11 VMs, automatically setting up essential tools and configurations. 
### Here’s what it does:
- Removes the Microsoft Edge icon from the desktop for a cleaner workspace.
- Installs Brave Browser (planning to add auto-default browser settings).
- Installs 7-Zip for file compression.
- Installs Notepad++, a more robust text editor than the default Notepad.
- Installs Mullvad VPN (a solid VPN choice).
- Installs Discord, useful for bot development or other Discord-related activities.
- Installs qBittorrent for secure file downloads.
- Creates an RDP user so you can connect to the VM directly. (Be cautious with security settings to prevent unauthorized access.)
- Message Output to Discord to let you know VM is ready to connect to via RDP.
  
That’s it! This script automates my VM setup, making it ready to go with the tools I need.

### Todo:
- Auto Default Browser
- Randomly Generated RDP User lognis.
- Auto Agree for Winget so no manual input needed.
- Self Choose of Browser, VPN Client, Torrent Software and File Compression Software.

