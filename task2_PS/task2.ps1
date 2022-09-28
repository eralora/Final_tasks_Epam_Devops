#Import account.csv and assifn to variable
$UserList = Import-Csv ./$args

#Make Name and Surname's first letter uppercase
foreach ($row in $UserList) {
    $row.name = (Get-Culture).TextInfo.ToTitleCase($row.name)
}

#Take first letter from name and last name and store it temproary in email column
foreach ($row in $UserList) {
    $name,$sname = ($row.name.tolower()).Split(" ")
    $nsname = $name[0]+$sname
    $row.email = $nsname
}

#Create aray which store only duplicated email names
$d = @($UserList | Group 'email' | Where{$_.Count -gt 1})
$duplicated_emails = $d.name 

#Add to duplicated email names location id and domain name, fo others only domain name
foreach ($row in $UserList) {
    if ($duplicated_emails -match $row.email) {
        $row.email = $row.email+$row.location_id+"@abc.com"
    }
    else {
        $row.email = $row.email+"@abc.com"
    }

}

#Export to new file .\accounts_new.csv
$UserList | Export-Csv  .\accounts_new.csv
