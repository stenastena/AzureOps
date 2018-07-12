az login -t veeamonazure.onmicrosoft.com
pause
az group create --name rgLinux --location "Central US"
az group deployment create \
    --name LinuxDeployment \
    --resource-group rgLinux \
    --template-file LinuxVirtualMachine.json \
    --parameters @LinuxVirtualMachine.parameters.json
	
az group deployment create --name LinuxDeployment --resource-group rgLinux --template-file LinuxVirtualMachine.json --parameters  @LinuxVirtualMachine.parameters.json