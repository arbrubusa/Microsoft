# Import the AD module to the session
Import-Module ActiveDirectory

# Define the domain or domain controller you wish to consult
$domainController = "<PUT YOUR SEARCH DOMAIN HERE>"

#Search for the users and export report
Get-ADUser -filter * -properties Name, PasswordNeverExpires, PasswordLastSet, LastLogonDate -Server $domainController | where {
$_.passwordNeverExpires -eq "true" } |  Select-Object DistinguishedName,Name,Enabled,PasswordLastSet,LastLogonDate |
Export-csv C:\PATH\TO\FILE.csv -NoTypeInformation -Delimiter '|'
