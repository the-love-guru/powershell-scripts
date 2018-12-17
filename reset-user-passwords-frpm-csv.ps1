$path = "C:\support\Scripts\users.csv"
$csv = Import-csv -path $path

Function CheckUserExists
{
    try 
    
    {
        Write-Host "Checking earth.local if account exists" -ForegroundColor Yellow
        $DoesExist = Get-ADUser -Identity $userName
        #Invoke-Expression "Get-ADUser -Identity $userName" -ErrorVariable DoesExist
    }

    catch 
    
    {
        if ($error[0].exception -like "*Cannot find an object with identity*")
            {    
                Write-Host "Account does not exist" -ForegroundColor Yellow
                
            }


        else 

            {    
                Write-Host "ABORTED - Unable to varify account does not exist" -ForegroundColor Red
                Pause
                break
            }

    }

if ($DoesExist -eq $null)

    {
       Write-Host "ABORTED - Identity $samaccountname already exists in domain - earth.local" -ForegroundColor Red
       $DoesExist = $null
       pause
       break 
    }

}
Import-Csv $path | Foreach-Object { 

    foreach ($property in $_.PSObject.Properties)
    {
    
    if ($property.Name -eq 'Password'){
    $tempPass = $property.value
    }
    if ($property.Name -eq 'User'){
    $userName = $property.value
    Write-host $userName
    }
    CheckUserExists
    Set-ADAccountPassword -Identity $userName -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $tempPass -Force)
    } 

}
