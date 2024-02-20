function CheckAndEnableHyperV {
    try {
        $HyperVStatus = Get-WindowsFeature -Name Hyper-V

        if ($HyperVStatus.Installed) {
            Write-Host "Hyper-V is enabled."
        } else {
            Write-Host "Hyper-V was not enabled. Trying to enable it now."
            $result = Enable-WindowsFeature -Name Hyper-V

            if ($result.Success) {
                Write-Host "Now Hyper-V is enabled."
                ForceReboot
            } else {
                Write-Host "Error enabling Hyper-V."
                if ($result.ExitCode -ne 0) {
                    Write-Host "Error Details: $($result.ErrorMessage)"
                }
            }
        }
    } catch {
        Write-Host "An exception occurred. Trying to enable Hyper-V using DISM..."
        $dismOutput = dism /online /enable-feature /featurename:Microsoft-Hyper-V /All /NoRestart 2>&1
        $successPattern = "The operation completed successfully."

        if ($dismOutput -match $successPattern) {
            Write-Host "Hyper-V is enabled."
            ForceReboot
        } else {
            Write-Host "There was an error enabling Hyper-V. Check the DISM log at C:\Windows\Logs\DISM\dism.log for details."
            Write-Host "DISM Output: $dismOutput"
        }
    }
}
function ForceReboot {
    Write-Host "A reboot is required to complete the Hyper-V installation. Rebooting now..."
    Restart-Computer
}

CheckAndEnableHyperV