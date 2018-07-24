$VmName="vmjob24072018205418" #Задаем в переменную имя виртуальной машины
$RgName="rgTechno" #Задаем в переменную имя ресурсной группы

#Удаляем Public IP через отдельную функцию до остальных манипуляций с виртуальной машиной и ее компонентами
PublicIpDelete $VmName $RgName

# Получение объекта виртуальной машины
$VM=Get-AzureRmVM -Name $VmName -ResourceGroupName $RgName

# Получение объекта сетевого интерфейса для данной конкретной виртуальнй машины
$NicId = ((($VM).NetworkProfile).NetworkInterfaces).Id
# Получение строкого короткого имени сетевого интерфейса
$NicName = $NicId.substring($NicId.LastIndexOf("/")+1)

#Получение имени диска с данными
$DataDisks= $VM.StorageProfile.DataDisks

#Получение имени диска с операционной системой
$OsDisk= $VM.StorageProfile.OsDisk

# Отсоединяем (Detach) диск данных от виртуальной машины
Remove-AzureRmVMDataDisk -VM $VM

# Обновляем конфигурацию вирт маш
Update-AzureRmVM -ResourceGroupName $RgName -VM $VM

# Удаляем виртуальную машину
Remove-AzureRmVM -name $VmName -ResourceGroupName $RgName -Force

# Удаляем диск с данными
Remove-AzureRmDisk -ResourceGroupName $RgName -DiskName $DataDisks.Name -Force

# Удаляем диск с операционной системой
Remove-AzureRmDisk -ResourceGroupName $RgName -DiskName $OsDisk.Name -Force

# Удаляем сетевой интерфейс
# Remove-AzureRmVMNetworkInterface -VM $VM -NetworkInterfaceIDs $NicName  #Ошибок не выдает, но и интерфейс не удаляет

#Get-AzureRMVM -Name $VmName -ResourceGroupName $RgName | Remove-AzureRmVMNetworkInterface -Id $NicId #Ошибок не выдает, но и интерфейс не удаляет
#Get-AzureRMVM -Name $VmName -ResourceGroupName $RgName | Remove-AzureRmVMNetworkInterface -Id $NicName #Ошибок не выдает, но и интерфейс не удаляет
#Get-AzureRMVM -Name $VmName -ResourceGroupName $RgName | Remove-AzureRmVMNetworkInterface #Ошибок не выдает, но и интерфейс не удаляет


Remove-AzureRmNetworkInterface -ResourceGroupName $RgName -Name $NicName -Force # !!! Работает после удаления VM

#Откуда-то
#Get-AzureRMVM -ResourceGroupName xxx -Name yyy | Remove-AzureRmVMNetworkInterface -Id "old-nic-id"


#Write-Output "Full info"
#$VM

#Write-Output
#echo
#Write-Output "Hardware info"
#$VM.HardwareProfile

#Write-Output "Network info"
#$VM.NetworkProfile


#Write-Output "Storage info"
#$VM.StorageProfile

#Write-Output "OS info"
#$VM.OSProfile
#$VM.NetworkProfile.NetworkInterfaces.Id | Get-AzureRmNetworkInterfaceIpConfig

#Get-AzureNetworkInterfaceConfig -VM $VM.Name #$VmName

#Remove-AzureRmPublicIpAddress -Name $VM -ResourceGroupName $rg #Непонятно с  Name , что надо подставлять

# Отладка. Получение списка виртуальных машин
#Способ №1
#Get-AzureRmResource -ResourceGroupName rgTechno -ResourceType Microsoft.Compute/virtualMachines | Select-Object {$_.Name}
#Способ №2
#Get-AzureRmVM -ResourceGroupName rgTechno


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

# Для отсоединения публичного адреса от сетевого интерфейса обнуляем IpConfiguration для объекта "Public IP address" 
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