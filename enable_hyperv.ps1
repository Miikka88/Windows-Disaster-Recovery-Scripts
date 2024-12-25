param(
    [switch]$NoReboot
)

function ForceReboot {
    if (-not $NoReboot) {
        Write-Host "A reboot is required to complete the Hyper-V installation. Rebooting now..."
        Restart-Computer
    }
    else {
        Write-Host "A reboot is required, but ‘NoReboot’ was specified. Please restart manually."
    }
}

function CheckAndEnableHyperV {
    # Ensure script is running as Administrator
    if (-not ([bool] (New-Object Security.Principal.WindowsPrincipal(
                    [System.Security.Principal.WindowsIdentity]::GetCurrent()
                )).IsInRole([System.Security.Principal.WindowsBuiltinRole]::Administrator))) {
        Write-Host "This script must be run as Administrator. Exiting."
        return
    }

    try {
        $HyperVStatus = Get-WindowsFeature -Name Hyper-V

        if ($HyperVStatus.Installed) {
            Write-Host "Hyper-V is already enabled."
        }
        else {
            Write-Host "Hyper-V was not enabled. Trying to enable it now..."

            $result = Enable-WindowsFeature -Name Hyper-V

            if ($result.Success) {
                Write-Host "Hyper-V has been enabled successfully."
                ForceReboot
            } 
            else {
                Write-Host "Error enabling Hyper-V via Enable-WindowsFeature."
                if ($result.ExitCode -ne 0) {
                    Write-Host "Error Details: $($result.ErrorMessage)"
                }
            }
        }

    } catch {
        Write-Host "An exception occurred using Windows Feature approach: $($_.Exception.Message)"
        Write-Host "Trying to enable Hyper-V using DISM..."

        # Fallback to using DISM (works on both client and server)
        $dismOutput = dism /online /enable-feature /featurename:Microsoft-Hyper-V /All /NoRestart 2>&1
        $successPattern = "The operation completed successfully."

        if ($dismOutput -match $successPattern) {
            Write-Host "DISM reports success. Hyper-V is enabled."
            ForceReboot
        } 
        else {
            Write-Host "There was an error enabling Hyper-V via DISM."
            Write-Host "Check the DISM log at C:\Windows\Logs\DISM\dism.log for details."
            Write-Host "DISM Output:"
            Write-Host "$dismOutput"
        }
    }
}

CheckAndEnableHyperV
