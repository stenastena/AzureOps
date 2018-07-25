$VmName="Vmjob19072018170352"
$rg="rgTechno"

$VM=Get-AzureRmVM -Name $VmName -ResourceGroupName $rg

#Get-AzureRmNetworkInterface -ResourceGroupName $rg -Name ToString($VM.NetworkProfile)

$nic = ((($VM).NetworkProfile).NetworkInterfaces).Id 

$VM



$nic

Write-Output ""
Write-Output "NIC:"

$nicname = $nic.substring($i.LastIndexOf("/")+1)
$nicname 

Write-Output ""
Write-Output "PublicIP:"



#Get-AzureRmPublicIpAddress -NetworkInterfaceName 

#$PIP=Get-AzureRmPublicIpAddress -ResourceGroupName $rg 
#Работает! и выдает все PIP в ресурсной группе

#$PIP=Get-AzureRmPublicIpAddress -ResourceGroupName $rg -NetworkInterfaceName $nic #не работает
#$PIP=Get-AzureRmPublicIpAddress -ResourceGroupName $rg -NetworkInterfaceName $nicname #не работает


$PIP.Name


