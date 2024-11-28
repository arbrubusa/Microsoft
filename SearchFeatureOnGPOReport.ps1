# Directory where the XML Reports are stored
$reportDir = "C:\<PATH TO YOUR DIRECTORY>"

# Lista de termos alternativos para busca
$searchPatterns = @(
    "SEARCH TERM 1",
    "SEARCH TERM 2"
)

Write-Host "Searching for related configurations in the XML reports..." -ForegroundColor Green
$results = @()

# Run through all XML files for the search terms
Get-ChildItem -Path $reportDir -Filter *.xml | ForEach-Object {
    $content = Get-Content -Path $_.FullName
    foreach ($pattern in $searchPatterns) {
        if ($content -match $pattern) {
            Write-Host "Found configuration in GPO: $($_.BaseName)" -ForegroundColor Cyan
            $results += [PSCustomObject]@{
                GPOName  = $_.BaseName
                FilePath = $_.FullName
                FoundTerm = $pattern
            }
            break # break the loop to avoid duplicates
        }
    }
}

# Mostrar os resultados
if ($results.Count -gt 0) {
    Write-Host "`nConfigurations found in the following GPOs:" -ForegroundColor Green
    $results | Format-Table -AutoSize
} else {
    Write-Host "`nNo related configuration has been found." -ForegroundColor Red
}
