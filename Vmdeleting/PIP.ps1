$VmName="Vmjob21072018122559"
$RgName="rgTechno"

PublicIpDelete $VmName $RgName

############# Функция удаления  Public Ip Address ###################################
function PublicIpDelete ($Vm1, $rg1)
{
# Получение объекта виртуальной машины
$VM=Get-AzureRmVM -Name $Vm1 -ResourceGroupName $rg1

# Получение объекта сетевого интерфейса для данной конкретной виртуальнй машины
$NicId = ((($VM).NetworkProfile).NetworkInterfaces).Id

# Отладка. Проверяем полное имя сетевого интерфейса
#Write-Output "nicID"
#$NicId

# Получение строкого короткого имени сетевого интерфейса
$NicName = $NicId.substring($NicId.LastIndexOf("/")+1)
# Отладка. Проверяем короткое имя сетевого интерфейса
#Write-Output ""
#Write-Output "nicname"
#$NicName

# Получение объекта сетевого интерфеса
$nic = Get-AzureRmNetworkInterface -Name $nicname  -ResourceGroup $rg

# Получение имени  Public IP Address
$PipId = $nic.IpConfigurations.publicipaddress.id
# Отладка. Проверяем имя Public IP Address
#Write-Output ""
#Write-Output "PipId"
#$PipId

# Преобразование в короткое имя Public IP Address
$PipName = $PipId.substring($PipId.LastIndexOf("/")+1)
Write-Output ""
Write-Host "Удаляем публичный IP адрес: "
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
}