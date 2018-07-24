$VmName="Vmjob24072018201932"
$RgName="rgTechno"

#Получение сведений о конкретной виртуальной машине
#$VM= Get-AzureRmVM -ResourceGroupName rgTechno -Name $VmName

# Получение объекта виртуальной машины
$VM=Get-AzureRmVM -Name $VmName -ResourceGroupName $RgName

#Write-Host ""
#Write-Host "VM"
#Write-Host $VM    #Выдает только полную цепь происхождения объекта
#$VM

#$StorageProfile=$VM.StorageProfile
#Write-Host ""
#Write-Host "VM.StorageProfile"
#Write-Host $StorageProfile
#$StorageProfile

#$DataDisks= $VM.StorageProfile.DataDisks
#Write-Host ""
#Write-Host "VM.StorageProfile.DataDisks"
#$DataDisks

#Получение имени диска с данными
$DataDisks= $VM.StorageProfile.DataDisks
Write-Host ""
Write-Host "VM.StorageProfile.DataDisks.Name"
$DataDisks.Name

#$OsDisk= $VM.StorageProfile.OsDisk
#Write-Host ""
#Write-Host "VM.StorageProfile.OsDisk"
#$OsDisk

#Получение имени диска с операционной системой
$OsDisk= $VM.StorageProfile.OsDisk
Write-Host ""
Write-Host "VM.StorageProfile.OsDisk.Name"
#Write-Host $OsDisk
$OsDisk.Name

# Отсоединяем (Detach) диск данных от виртуальной машины
Remove-AzureRmVMDataDisk -VM $VM

# Обновляем конфигурацию вирт маш
Update-AzureRmVM -ResourceGroupName $RgName -VM $VM

# Удаляем виртуальную машину
#Remove-AzureRmVM -name $VmName -ResourceGroupName $rg # Почему-то удалилось, несмотря на неправильное имя рус группы
Remove-AzureRmVM -name $VmName -ResourceGroupName $RgName -Force # Нао пробовать вот так

# Удаляем диск с данными
Remove-AzureRmDisk -ResourceGroupName $RgName -DiskName $DataDisks.Name -Force

# Удаляем диск с операционной системой
Remove-AzureRmDisk -ResourceGroupName $RgName -DiskName $OsDisk.Name -Force

