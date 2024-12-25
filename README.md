Windows-DR-Scripts
This is going to be a collection of PowerShell scripts designed to facilitate disaster recovery on Windows platforms. These scripts help to automate various tasks after a failover or disaster scenario.


Scripts
enable_hyperv.ps1
Description
This script checks if Hyper-V is enabled on the local machine. If it’s not:

It attempts to enable the Hyper-V feature using Enable-WindowsFeature (on Windows Server).
If that fails or isn’t available (e.g., on Windows 10/11 Pro), it falls back to DISM to enable Hyper-V.
Key Features
Automatic Reboot: By default, if Hyper-V is successfully enabled, the system will reboot immediately to complete the installation.
Optional -NoReboot Parameter: Prevents the script from rebooting automatically, giving you the flexibility to reboot at a later time.
Error Handling: If the script encounters an error with the ServerManager cmdlets, it logs the issue and retries via DISM.
Usage
Open PowerShell as Administrator.
Navigate to the script directory:
powershell
Kopioi koodi
cd C:\Path\To\Windows-DR-Scripts
Run the script:
powershell
Kopioi koodi
.\enable_hyperv.ps1
This will attempt to enable Hyper-V and reboot automatically (unless you specify otherwise).
Skip Automatic Reboot if needed:
powershell
Kopioi koodi
.\enable_hyperv.ps1 -NoReboot
In this case, make sure to reboot manually to complete the installation.
Prerequisites
Windows Server or Windows 10/11 Pro/Enterprise/Education.
Administrator privileges (right-click PowerShell → “Run as Administrator”).
Hardware virtualization support enabled in BIOS/UEFI
