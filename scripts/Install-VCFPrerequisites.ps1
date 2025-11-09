<#
.SYNOPSIS
    Install VMware Cloud Foundation PowerCLI prerequisites

.DESCRIPTION
    Automated installation of required PowerShell modules and dependencies for VCF automation

.EXAMPLE
    Install-VCFPrerequisites

.NOTES
    Requires PowerShell 7.2+ and internet connectivity
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

try {
    Write-Host "Installing VMware Cloud Foundation PowerCLI Prerequisites..." -ForegroundColor Cyan
    
    # Check PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 7 -or 
        ($PSVersionTable.PSVersion.Major -eq 7 -and $PSVersionTable.PSVersion.Minor -lt 2)) {
        throw "PowerShell 7.2 or later is required. Current version: $($PSVersionTable.PSVersion)"
    }
    
    # Set execution policy
    Write-Host "Setting execution policy..." -ForegroundColor Yellow
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    
    # Install NuGet provider
    Write-Host "Installing NuGet provider..." -ForegroundColor Yellow
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser
    
    # Trust PowerShell Gallery
    Write-Host "Trusting PowerShell Gallery..." -ForegroundColor Yellow
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    
    # Install VMware PowerCLI
    Write-Host "Installing VMware PowerCLI..." -ForegroundColor Yellow
    if ($Force) {
        Install-Module -Name VMware.PowerCLI -MinimumVersion 13.3.0 -Scope CurrentUser -Force
    } else {
        Install-Module -Name VMware.PowerCLI -MinimumVersion 13.3.0 -Scope CurrentUser -AllowClobber
    }
    
    # Install VCF PowerCLI
    Write-Host "Installing VCF PowerCLI..." -ForegroundColor Yellow
    if ($Force) {
        Install-Module -Name VCF.PowerCLI -RequiredVersion 9.0.0.24798382 -Scope CurrentUser -Force
    } else {
        Install-Module -Name VCF.PowerCLI -RequiredVersion 9.0.0.24798382 -Scope CurrentUser -AllowClobber
    }
    
    # Configure PowerCLI
    Write-Host "Configuring PowerCLI..." -ForegroundColor Yellow
    Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User
    Set-PowerCLIConfiguration -ParticipateInCEIP $false -Confirm:$false -Scope User
    Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -Confirm:$false -Scope User
    
    # Verify installation
    Write-Host "Verifying installation..." -ForegroundColor Yellow
    $modules = Get-Module -Name VMware.PowerCLI, VCF.PowerCLI -ListAvailable
    
    Write-Host "`nInstalled Modules:" -ForegroundColor Green
    $modules | Select-Object Name, Version | Format-Table -AutoSize
    
    Write-Host "Prerequisites installation completed successfully!" -ForegroundColor Green
}
catch {
    Write-Error "Prerequisites installation failed: $($_.Exception.Message)"
    throw
}# Updated Sun Nov  9 12:52:11 CET 2025
# Updated Sun Nov  9 12:56:50 CET 2025
# File updated 1762692693
