# Windows-Disaster-Recovery-Scripts 

This repository contains a collection of PowerShell scripts designed to facilitate disaster recovery on Windows platforms. These scripts help automate various tasks after a failover or disaster scenario.


## Scripts

### `enable_hyperv.ps1`

#### Description
This script checks if Hyper-V is enabled on the local machine. If it’s not:

1. It attempts to enable the Hyper-V feature using `Enable-WindowsFeature` (on Windows Server).  
2. If that fails or isn’t available (for instance, on Windows 10/11 Pro), it falls back to DISM to enable Hyper-V.

#### Key Features
- **Automatic Reboot**: By default, if Hyper-V is successfully enabled, the system will reboot immediately to finalize the installation.  
- **Optional `-NoReboot` Parameter**: Prevents the script from rebooting automatically, giving you the flexibility to reboot at a later time.  
- **Error Handling**: If the script encounters an error with the ServerManager cmdlets, it logs the issue and retries the enablement via DISM.

#### Usage

1. **Open PowerShell as Administrator**

2. **Navigate to the script directory:**
   ```powershell
   cd C:\Path\To\Windows-DR-Scripts
3. **Run the script**
   ```powershell
   .\enable_hyperv.ps1
4. **Skip automated Reboot if needed**
   ```powershell
   .\enable_hyperv.ps1 -NoReboot

#### Prerequisites
Windows Server or Windows 10/11 Pro/Enterprise/Education.
Administrator privileges (right-click PowerShell → “Run as Administrator”).
Hardware virtualization support enabled in BIOS/UEFI.
