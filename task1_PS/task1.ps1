#Check of 3 arguments.
if ($args.Count -ne 3){
    Write-Error -Message "It should be 3 arguments. Please try again" -ErrorAction Stop 
}

#Pattern of IP address from 0.0.0.0 - 255.255.255.255
$pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"

#$pattern of Subnet address 255.0.0.0.0- 255.255.255.255


#Pattern of Subnet prefix 0-32
$pattern2 = "^([0-9]|[12][0-9]|3[012])$"


#Check of input format
if (!($args[0] -match $pattern)){
    Write-Error -Message "First argument should be IP address. Format should be x.x.x.x .  Please try again." -ErrorAction Stop  
}

elseif (!($args[1] -match $pattern)) {
    Write-Error -Message "Second argument should be IP address. Format should be x.x.x.x .  Please try again." -ErrorAction Stop 
}

elseif ((!($args[2] -match $pattern)) -and (!($args[2] -match $pattern2)))  {
    Write-Error -Message "Third argument should be Subnet mask address or subnet prefix. Format should be x.x.x.x or for prefix xx .  Please try again." -ErrorAction Stop  
}


else {

    #If user type prefix doing some calculation to convert prefix to int
    if ($args[2] -match $pattern2){

        $bitString=('1' * $args[2]).PadRight(32,'0')

        $ipString=[String]::Empty

        #Make 1 string combining a string for each byte and convert to int
        for($i=0;$i -lt 32;$i+=8){

            $byteString=$bitString.Substring($i,8)
            $ipString+="$([Convert]::ToInt32($byteString, 2))."

        }
            $mask = [ipaddress]$ipString.TrimEnd('.')
    
    }
    else {

        $mask = [ipaddress]$args[2]

    }
    #Assign two IP addresses to 2 variables 
    $ip1 = [ipaddress]$args[0]
    $ip2 = [ipaddress]$args[1]

    #Check if they belong in the same network using -band for binary comparison of two IP addresses
    if (($ip1.address -band $mask.address) -eq ($ip2.address -band $mask.address)) {
        Write-Output "Yes"
    }
    else {
        Write-Output "No"
    }

}



