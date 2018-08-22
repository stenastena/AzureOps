<#
Скрипт удаления виртуальной машины в Azure.
Надо задавать два параметра в командной строке:
DeleteVM имя_виртуальной_машины имя_ресурсной_группы

имя_виртуальной_машины - обязательный параметр
имя_ресурсной_группы, если не указано - rgTechno

Виртуальная сеть и диск хранения логов мониторинга не удаляются.
#>

Param (
$VmName, #Первый параметр командной строки - имя удаляемой виртуальной машины
$RgName="rgTechno" #Второй параметр командной строки - имя ресурсной группы где расположена удаляемая виртуальная машина
)

############# Функция удаления  Public Ip Address ###################################
function PublicIpDelete ($Vm1, $rg1)
{
# Получение объекта виртуальной машины
$VM=Get-AzureRmVM -Name $Vm1 -ResourceGroupName $rg1

# Получение объекта сетевого интерфейса для данной конкретной виртуальнй машины
$NicId = ((($VM).NetworkProfile).NetworkInterfaces).Id

# Получение строкого короткого имени сетевого интерфейса
$NicName = $NicId.substring($NicId.LastIndexOf("/")+1)

# Получение объекта сетевого интерфеса
$nic = Get-AzureRmNetworkInterface -Name $nicname  -ResourceGroup $rg1

# Получение имени  Public IP Address
$PipId = $nic.IpConfigurations.publicipaddress.id

# Преобразование в короткое имя Public IP Address
$PipName = $PipId.substring($PipId.LastIndexOf("/")+1)
Write-Output ""
Write-Host "Удаляем публичный IP адрес: "
$PipName

# Для отсоединения публичного адреса от сетевого интерфейса обнуляем IpConfiguration для объекта "Public IP address" 
$nic.IpConfigurations.PublicIpAddress.id = ""
Set-AzureRmNetworkInterface -NetworkInterface $nic

# Удаляем Public Ip Address только после отвязки (Dissociating) от сетевого интерфейса
Remove-AzureRmPublicIpAddress -Name $PipName -ResourceGroupName $rg1 -Force
}
############# Конец функции удаления  Public Ip Address###################################


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
Remove-AzureRmNetworkInterface -ResourceGroupName $RgName -Name $NicName -Force # !!! Работает после удаления VM

