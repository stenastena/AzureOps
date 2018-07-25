$VmName="Vmjob19072018170352"
$rg="rgTechno"

$nic = (((Get-AzureRmVM).NetworkProfile).NetworkInterfaces).Id
ForEach ($i in $nic) {
  $nicname = $i.substring($i.LastIndexOf("/")+1)
  Get-AzureRmNetworkInterface -Name $nicname -ResourceGroupName $rg | Get-AzureRmNetworkInterfaceIpConfig | select-object  PrivateIpAddress,PrivateIpAllocationMethod
}
