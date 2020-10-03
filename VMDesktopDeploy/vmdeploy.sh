#!/bin/bash

# Используем если требуется каждый раз логиниться в Azure
#az login
#az account set --subscription f5b5d7b3-27e6-47ba-83c1-58824d3eb42b

#==============================================================================
# Задаем переменные
#
# Задаем имя ресурсной группы в которой будем создавать ресурс
rgname="rgIntune"
#
# Расположение
location='westeurope' 
#
# Главный шаблон, в котором находятся все настройки. Шаблон в формате json
template='azuredeploy.json'
#
# Добавочный шаблон с входными параметрами для развертывания.
# Конкретизирует отдельные параметры относительно основного шаблона.
# Если его не будет, то все параметры будут стоять по умолчанию.
parms='azuredeploy.parameters.json'
#==============================================================================

# Название деплоймента, чтобы потом отслеживать какое развертывание было удачным или нет и с какими event_ами
# Также, название деплоймента используется для создания уникальных именований виртуальных машин
# Пример из Powershell job = 'vm' + (Get-Date).tostring("ddMMyyyyHHmmss")
#job=$(head /dev/urandom | tr -dc a-z0-9 | head -c 16)
job=$(date "+%d%m%y%H%M%S")

#Создание ресурсной группы
az group create --location $location --name $rgname

#Основная команда для инициализации развертывания из шаблона. 
az group deployment create --name $job  --resource-group $rgname --template-file $template --parameters $parms 
#az group deployment create --name $job  --resource-group $rgname --template-file $template --parameters $parms --debug