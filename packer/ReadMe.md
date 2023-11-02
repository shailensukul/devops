# Packer
A test folder to leaern Packer

[Gist reference](https://gist.github.com/shailensukul/fdb0d853248e5fc331c29dcad1d753b9)

<https://learn.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer>

Install Packer <https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli>

`choco install packer`

Create resource group

`az group create -n packerDemoRG -l eastus`

Create service principal

`az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"`

Subscription id

`az account show --query "{ subscription_id: id }"`

Define packer template

Optional: Upgrade JSON tempate below to HCL2: `packer hcl2_upgrade my-template.json`

[HCL2 Template](./ubuntu.json.pkr.hcl)

Initializer packer
`packer init ubuntu.json.pkr.hcl`

Build packer image

`packer build ubuntu.json.pkr.hcl`

Create VM From Azure Image

```
az vm create --resource-group packerDemoRG --name myVM --image myPackerImage --admin-username azureuser --generate-ssh-keys

```

Open port

```
az vm open-port --resource-group packerDemoRG --name myVM --port 80

```

Browse to url

`http://publicIpAddress`


Cleanup
`az group delete -n packerDemoRG -y`