$servers = Get-Content "C:\Servers.txt"
$warn = 0
Write-Host "Starting Check"
foreach ($s in $servers)
{
## Check for the update folder
if(Test-Path \\$s\d$\update){
Write-Host "Update folder exists"}
else{new-item \\$s\d$\update -itemtype directory
Write-Host "Update folder created"}

## Copy the files
Copy-Item C:\Sage.LicCommon.4.Azure.zip -Destination \\$s\D$\Update -force

## Extract the files
Invoke-Command -ComputerName $s -FilePath 'C:\Scripts\Extract.ps1'

## Run the Batch file.
$r = New-PSSession -Computername $s 
Invoke-Command -Session $r -ScriptBlock {Start-Process "d:\update\Sage.LicCommon.4.Azure\run.bat"} -AsJob 
Disconnect-PSSession -Session $r

## Check for the Licence dll in D:\update

if(Test-Path \\$s\d$\update\Sage.LicCommon.4.Azure\Sage.LicCommon.dll){

"$s /yes`n" | out-file c:\Licencelog.txt -append}

else{"$s /no`n" | out-file c:\Licencelog.txt -append}
                                       
}

