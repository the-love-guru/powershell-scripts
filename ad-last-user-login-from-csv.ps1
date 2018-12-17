$path = "C:\support\Scripts\users.csv"
$PathExport = 'C:\support\LastLogons.csv'

Import-Csv $path | Foreach-Object { 

    foreach ($property in $_.PSObject.Properties)
    {
    if ($property.Name -eq 'User'){
    $userName = $property.value
    }
    Get-ADUser -Filter {SamAccountName -eq $username} -Properties LastLogonTimeStamp |
    Select-Object Name,@{Name="Stamp"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp).ToString('yyyy-MM-dd_hh:mm:ss')}} | Export-Csv -Path $PathExport –notypeinformation -append
    } 

}
 
