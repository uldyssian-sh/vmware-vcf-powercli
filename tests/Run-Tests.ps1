<#
.SYNOPSIS
    Run all VCF PowerCLI tests

.DESCRIPTION
    Executes unit and integration tests for VCF PowerCLI automation

.EXAMPLE
    .\Run-Tests.ps1
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Unit", "Integration", "All")]
    [string]$TestType = "All"
)

try {
    Import-Module Pester -Force
    
    $testResults = @()
    
    switch ($TestType) {
        "Unit" {
            Write-Host "Running Unit Tests..." -ForegroundColor Yellow
            $testResults += Invoke-Pester -Path "./Unit" -PassThru
        }
        "Integration" {
            Write-Host "Running Integration Tests..." -ForegroundColor Yellow
            $testResults += Invoke-Pester -Path "./Integration" -PassThru
        }
        "All" {
            Write-Host "Running All Tests..." -ForegroundColor Yellow
            $testResults += Invoke-Pester -Path "./Unit" -PassThru
            $testResults += Invoke-Pester -Path "./Integration" -PassThru
        }
    }
    
    # Summary
    $totalTests = ($testResults | Measure-Object -Property TotalCount -Sum).Sum
    $passedTests = ($testResults | Measure-Object -Property PassedCount -Sum).Sum
    $failedTests = ($testResults | Measure-Object -Property FailedCount -Sum).Sum
    
    Write-Host "`nTest Summary:" -ForegroundColor Cyan
    Write-Host "Total: $totalTests | Passed: $passedTests | Failed: $failedTests" -ForegroundColor White
    
    if ($failedTests -gt 0) {
        exit 1
    }
}
catch {
    Write-Error "Test execution failed: $($_.Exception.Message)"
    exit 1
}