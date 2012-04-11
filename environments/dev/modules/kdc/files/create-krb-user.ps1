# script to create AD user and Kerberos principal for Kerberized Unix service
# Usage: create-krb-user.ps1 servicetype hostname
# Example: create-krb-user.ps1 nfs scratchy

add-pssnapin quest.activeroles.admanagement

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

$serviceType=$args[0]
$hostName=$args[1]
$hostNameLower=$hostname.ToLower()
$hostNameCapital=(Get-Culture).TextInfo.ToTitleCase($hostNameLower)

$myDomainLower=[System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().name
$myDomain=$myDomainLower.ToUpper()
$atDomain="@"+$myDomain
$atDomainLower=$atDomain.ToLower()

$fqdn=$hostNameLower+"."+$myDomainLower

$serviceUser=$serviceType+$hostNameCapital

if (get-qaduser $serviceUser) {
  echo "$serviceUser exists"
} else {
  echo "$serviceUser does not exist"
  #Set up random number generator
  $rand = New-Object System.Random
  #Generate a new 10 character password for the user account
  $newPassword=""
  1..10 | ForEach { $newPassword = $newPassword + [char]$rand.next(33,127) }
  echo "Creating $serviceUser"
  new-QADUser -name $serviceUser -ParentContainer 'CN=Users,DC=caedev,DC=local' -samAccountName $serviceUser -UserPassword $newPassword
  $principal=$serviceType+"/"+$fqdn+$atDomain
  $mapUser=$serviceUser+$atDomainLower
  $keytabFile=$serviceUser+".keytab"
  $keytabPath=Join-Path (Get-ScriptDirectory) $keytabFile
  echo "Mapping Kerberos principal $principal to $mapUser"
  ktpass -princ $principal -mapuser $mapUser +rndPass -ptype KRB5_NT_PRINCIPAL DesOnly -crypto DES-CBC-CRC -out $keytabPath
}
