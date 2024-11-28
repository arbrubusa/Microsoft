# Define the diretory to store the GPOs backups and reports
$backupDir = "C:\<PATH TO YOUR BACKUP DIRECTORY>"
$reportDir = "C:\<PATH TO YOUR REPORTS DIRECTORY>"

# Create the directory if they do not exist
if (!(Test-Path -Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
}

if (!(Test-Path -Path $reportDir)) {
    New-Item -ItemType Directory -Path $reportDir | Out-Null
}

# Import Group Policy Management module
Import-Module GroupPolicy

# Export all GPOs to the directory defined to store the backups
Write-Host "Exporting all GPOs to the directory: $backupDir" -ForegroundColor Green
Get-GPO -All | ForEach-Object {
    Write-Host "Exporting GPO: $($_.DisplayName)" -ForegroundColor Yellow
    Backup-GPO -Name $_.DisplayName -Path $backupDir -ErrorAction SilentlyContinue
}

# Generate XML reports for all the exported GPOs
Write-Host "Generating XML reports for all the GPOs in this directory: $reportDir" -ForegroundColor Green
Get-GPO -All | ForEach-Object {
    $reportPath = Join-Path -Path $reportDir -ChildPath "$($_.DisplayName).xml"
    Write-Host "Generating report for GPO: $($_.DisplayName)" -ForegroundColor Yellow
    Get-GPOReport -Name $_.DisplayName -ReportType XML -Path $reportPath
}
