$VmName="Vmjob21072018122559"
$rg="rgTechno"

$VM=Get-AzureRmVM -Name $VmName -ResourceGroupName $rg

############# Удаляем Public Ip Address ###################################
$NicId = ((($VM).NetworkProfile).NetworkInterfaces).Id

Write-Output "nicID"
$NicId

$NicName = $NicId.substring($NicId.LastIndexOf("/")+1)
Write-Output ""
Write-Output "nicname"
$NicName

$nic = Get-AzureRmNetworkInterface -Name $nicname  -ResourceGroup $rg

$PipId = $nic.IpConfigurations.publicipaddress.id
Write-Output ""
Write-Output "PipId"
$PipId

$PipName = $PipId.substring($PipId.LastIndexOf("/")+1)
Write-Output ""
Write-Output "PipName"
$PipName

# Отладка. Проверяем свойства объекта "Public IP address" ДО отвязки от сетевого интерфейса
#$pipObj=get-AzureRmPublicIpAddress  -Name $PipName -ResourceGroupName $rg
#Write-Output ""
#Write-Output "pipObj до обнуления"
#$pipObj

# Обнуляем IpConfiguration для объекта "Public IP address"
$nic.IpConfigurations.PublicIpAddress.id = ""
#$PipId="" #через переменную не обнуляет
Set-AzureRmNetworkInterface -NetworkInterface $nic

# Отладка. Проверяем свойства объекта "Public IP address"  ПОСЛЕ отвязки от сетевого интерфейса
#$pipObj=get-AzureRmPublicIpAddress  -Name $PipName -ResourceGroupName $rg
#Write-Output ""
#Write-Output "pipObj после обнуления"
#$pipObj

# Удаляем Public Ip Address только после отвязки (Dissociating) от сетевого интерфейса
Remove-AzureRmPublicIpAddress -Name $PipName -ResourceGroupName $rg -Force

############# Удалили Public Ip Address ###################################
