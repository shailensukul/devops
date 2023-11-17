# Change these four parameters as needed
MOODLE_RESOURCE_GROUP=moodleRG \
MOODLE_DB_SERVER_NAME=moodledb$RANDOM \
MOODLE_DB_USER=dbadmin \
MOODLE_DB_USER_PWD=f4fGDsgr4$332 \
MOODLE_DB_SKU=Standard_B1ms \
MOODLE_LOCATION=eastus \
MOODLE_VM_NAME=moodleVM \
MOODLE_PERS_STORAGE_ACCOUNT_NAME=moodlestorage$RANDOM \
MOODLE_PERS_LOCATION=eastus \
MOODLE_PERS_SHARE_NAME=moodleshare \
MOODLE_VIRTUAL_NETWORK=moodlevirtualnetwork \
MOODLE_VIRTUAL_SUBNET=moodlesubnet \
MOODLE_VIRTUAL_SUBNET_DB=moodledbsubnet \
MOODLE_DB_NIC=moodledbnic \
MOODLE_PRIVATE_ENDPOINT=moodleprivateendpoint 

# Packer
A test folder to learn Packer

[Gist reference](https://gist.github.com/shailensukul/fdb0d853248e5fc331c29dcad1d753b9)

<https://learn.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer>

Install Packer <https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli>

`choco install packer`

Create resource group

```
az group create -n $MOODLE_RESOURCE_GROUP -l $MOODLE_LOCATION
```

Create service principal

`az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

Subscription id

`az account show --query "{ subscription_id: id }"`

# Create a virtual network
```
az network vnet create \
    --name $MOODLE_VIRTUAL_NETWORK \
    --resource-group $MOODLE_RESOURCE_GROUP \
    --address-prefix 10.0.0.0/16 \
    --subnet-name $MOODLE_VIRTUAL_SUBNET \
    --subnet-prefixes 10.0.0.0/24
```

# Create a subnet for the managed database
```
az network vnet subnet create \
--resource-group $MOODLE_RESOURCE_GROUP \
 --vnet-name $MOODLE_VIRTUAL_NETWORK \
 --name $MOODLE_VIRTUAL_SUBNET_DB \
  --address-prefixes 10.0.1.0/24
 ```
  
# Disable subnet private endpoint policies
 ```
az network vnet subnet update \
 --name $MOODLE_VIRTUAL_SUBNET_DB \
 --resource-group $MOODLE_RESOURCE_GROUP \
 --vnet-name $MOODLE_VIRTUAL_NETWORK \
 --disable-private-endpoint-network-policies true
```
 
# Create the Managed Database

List all available SKUs for a given region
```
az mysql flexible-server list-skus -l $MOODLE_LOCATION 
```

TODO: Set require_secure_transport to OFF
- Create the bitnami_moodle db
Create the db server
```
az mysql flexible-server create \
--resource-group $MOODLE_RESOURCE_GROUP \
--name $MOODLE_DB_SERVER_NAME \
--location $MOODLE_LOCATION \
--admin-user $MOODLE_DB_USER \
--admin-password $MOODLE_DB_USER_PWD \
--sku-name $MOODLE_DB_SKU \
--tier Burstable \
--iops 500 \
--storage-size 32  \
--zone 1 --yes \
--vnet $MOODLE_VIRTUAL_NETWORK \
--subnet $MOODLE_VIRTUAL_SUBNET_DB \
--version 8.0.21 \
--tags "require_secure_transport=OFF"
```

```
az mysql flexible-server db create --resource-group $MOODLE_RESOURCE_GROUP --server-name moodledb20402 --database-name bitnami_moodle
```

Define packer template

Optional: Upgrade JSON tempate below to HCL2: `packer hcl2_upgrade my-template.json`

[HCL2 Template](./ubuntu.json.pkr.hcl)

Initializer packer
`packer init moodle.json.pkr.hcl`

Build packer image

```
packer build moodle.json.pkr.hcl
```

Create VM From Azure Image

```
az vm create --resource-group $MOODLE_RESOURCE_GROUP \
--name $MOODLE_VM_NAME --image moodleImage \
--admin-username azureuser --generate-ssh-keys \
--vnet-name $MOODLE_VIRTUAL_NETWORK \
  --subnet $MOODLE_VIRTUAL_SUBNET 
  #--nics $MOODLE_DB_NIC

```

Open port

```
az vm open-port --resource-group $MOODLE_RESOURCE_GROUP --name $MOODLE_VM_NAME --port 80
```

Browse to url

`http://publicIpAddress`


Check connectivity to mysql
```
sudo apt install mysql-client-core-8.0
```

```
mysql --host=moodledb21806.mysql.database.azure.com --user=dbadmin --password=f4fGDsgr4$332 mysql
```


https://stackoverflow.com/questions/73228021/bitnami-moodle-container-does-not-connec-to-maria-db

Auto mount file shares
https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux?tabs=Ubuntu%2Csmb311#automatically-mount-file-shares

Cleanup
```
az group delete -n $MOODLE_RESOURCE_GROUP -y
```

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
