# Packer
A test folder to leaern Packer

[Gist reference](https://gist.github.com/shailensukul/fdb0d853248e5fc331c29dcad1d753b9)

<https://learn.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer>

Install Packer <https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli>

`choco install packer`

Create storage (skip this for now)
# Change these four parameters as needed
MOODLE_RESOURCE_GROUP=moodleRG
MOODLE_DB_NAME=moodledb$RANDOM
MOODLE_DB_USER=dbadmin
MOODLE_DB_USER_PWD=f4fGDsgr4$332
MOODLE_DB_SKU=B_Gen5_1
MOODLE_LOCATION=eastus
MOODLE_VM_NAME=moodleVM

Create resource group

`az group create -n $MOODLE_RESOURCE_GROUP -l $MOODLE_LOCATION`

ACI_PERS_STORAGE_ACCOUNT_NAME=moodlestorage$RANDOM
ACI_PERS_LOCATION=eastus
ACI_PERS_SHARE_NAME=moodleshare

# Create the storage account with the parameters
az storage account create --resource-group $MOODLE_RESOURCE_GROUP --name $ACI_PERS_STORAGE_ACCOUNT_NAME --location $ACI_PERS_LOCATION --sku Standard_LRS --enable-large-file-share --output none


# Create the file share
shareName="moodleshare"

az storage share-rm create --resource-group $MOODLE_RESOURCE_GROUP --storage-account $ACI_PERS_STORAGE_ACCOUNT_NAME --name $shareName --access-tier "TransactionOptimized" --quota 1024 --output none

To mount an Azure file share as a volume in Azure Container Instances, you need three values: the storage account name, the share name, and the storage access key.

echo $ACI_PERS_STORAGE_ACCOUNT_NAME

STORAGE_KEY=$(az storage account keys list --resource-group $MOODLE_RESOURCE_GROUP --account-name $ACI_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" --output tsv)
echo $STORAGE_KEY

echo $ACI_PERS_SHARE_NAME

Create service principal

`az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

Subscription id

`az account show --query "{ subscription_id: id }"`

Create Managed Database
```
az mysql server create --resource-group $MOODLE_RESOURCE_GROUP --name $MOODLE_DB_NAME --location $MOODLE_LOCATION --admin-user $MOODLE_DB_USER --admin-password $MOODLE_DB_USER_PWD --sku-name $MOODLE_DB_SKU
```
Define packer template

Optional: Upgrade JSON tempate below to HCL2: `packer hcl2_upgrade my-template.json`

[HCL2 Template](./ubuntu.json.pkr.hcl)

Initializer packer
`packer init moodle.json.pkr.hcl`

Build packer image

`packer build moodle.json.pkr.hcl`

Create VM From Azure Image

```
az vm create --resource-group $MOODLE_RESOURCE_GROUP --name $MOODLE_VM_NAME --image moodleImage --admin-username azureuser --generate-ssh-keys

```

Open port

```
az vm open-port --resource-group $MOODLE_RESOURCE_GROUP --name $MOODLE_VM_NAME --port 80
```

Browse to url

`http://publicIpAddress`

https://stackoverflow.com/questions/73228021/bitnami-moodle-container-does-not-connec-to-maria-db

Auto mount file shares
https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux?tabs=Ubuntu%2Csmb311#automatically-mount-file-shares

Cleanup
`az group delete -n $MOODLE_RESOURCE_GROUP -y`

# Remove all containers and volumes
`docker stop $(docker ps -a -q)`

`docker rm $(docker ps -aq)`

 `docker volume prune`

 `docker system prune -a`

 # Moodle Details

Default: user
Default password: bitnami

user id : shailen
password: exam123

user id : shaiden
password: Shaiden123!
