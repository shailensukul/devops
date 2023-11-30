BICEP_RESOURCE_GROUP=bicepRG \
BICEP_DEPLOYMENT_STACK=bicepDS \
BICEP_LOCATION=eastus

az bicep version

az bicep upgrade

az group create --name $BICEP_RESOURCE_GROUP --location $BICEP_LOCATION

# Create Deployment Stack
az stack group create --name $BICEP_DEPLOYMENT_STACK --resource-group $BICEP_RESOURCE_GROUP --template-file './devops.bicep' --deny-settings-mode 'none'

# Verify the deployment
az stack group show --resource-group 'demoRg' --name $BICEP_DEPLOYMENT_STACK

# Update the deployment stack
az stack group create --name $BICEP_DEPLOYMENT_STACK --resource-group $BICEP_RESOURCE_GROUP --template-file './devops.bicep' --deny-settings-mode 'none'

# Delete the deployment stack
az stack group delete --name $BICEP_DEPLOYMENT_STACK --resource-group $BICEP_RESOURCE_GROUP --delete-all

# Cleanup
az group delete --name 'demoRg'