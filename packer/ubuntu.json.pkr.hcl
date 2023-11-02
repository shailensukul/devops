packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1"
    }
  }
}

source "azure-arm" "autogenerated_1" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = "94c9e95b-f35c-4deb-99f8-e6395b664988"
  client_secret                     = "b8y8Q~cO2X~dxTjBz3vLuaB_p5sc~.0ZBzHRccIX"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "East US"
  managed_image_name                = "myPackerImage"
  managed_image_resource_group_name = "myResourceGroup"
  os_type                           = "Linux"
  subscription_id                   = "ac71096c-a101-4272-8d7e-5662e3778cb1"
  tenant_id                         = "ddec9947-f88f-4b2d-8d27-f346c65f61a8"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.autogenerated_1"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    script = "install.sh"
    inline_shebang  = "/bin/sh -x"
  }

}
