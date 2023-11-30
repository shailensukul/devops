



@description('Generated from /subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.DBforMySQL/flexibleServers/moodledb20402')
resource moodledb 'Microsoft.DBforMySQL/flexibleServers@2023-06-30' = {
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: 'dbadmin'
    storage: {
      storageSizeGB: 32
      iops: 500
      autoGrow: 'Enabled'
      autoIoScaling: 'Disabled'
      logOnDisk: 'Disabled'
    }
    version: '8.0.21'
    availabilityZone: '1'
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'None'
    network: {
      publicNetworkAccess: 'Disabled'
      delegatedSubnetResourceId: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Network/virtualNetworks/moodlevirtualnetwork/subnets/moodledbsubnet'
      privateDnsZoneResourceId: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodlerg/providers/Microsoft.Network/privateDnsZones/moodledb20402.private.mysql.database.azure.com'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
  }
  location: 'East US'
  tags: {
    require_secure_transport: 'OFF'
  }
  name: 'moodledb20402'
}

@description('Generated from /subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/MOODLERG/providers/Microsoft.Compute/virtualMachines/moodleVM')
resource moodleVM 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: 'moodleVM'
  location: 'eastus'
  tags: {}
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Compute/images/moodleImage'
      }
      osDisk: {
        osType: 'Linux'
        name: 'moodleVM_disk1_9f1ad1b23d7e47fabdfeb773bced3ebe'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Compute/disks/moodleVM_disk1_9f1ad1b23d7e47fabdfeb773bced3ebe'
        }
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'moodleVM'
      adminUsername: 'azureuser'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/azureuser/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6HRCj7Q+h/ZMAUw20jlC4iSAJ07ryAmSdo2YzrNTHhbvxqqBqeXJqO66jvu3JX2PCIWhZa5LVOU5x7lxPX+TmrSUOtLjwREc2/wnCRBm5fgmUxlExDJkJAu15PHuAruRrIqundm1eqQIuwefX/2vQrDQmkDhFQBOyKSsT3nTXUAONNkb8JzFtFTGd3Z/BldcNqHIEIUYAAK0jQmSuRfrLBJVjWghawnZDuaQ3LT1vV7QuiE3FeNpHKaoOrczs4CB3yGXvDYuSepvcaEQNaFHeLmfani0bOyMuhhz9eC+491Za6S2Eg1cY8dRRBkZumD+p9o5+ajPmGnYU+XPNf2PwuaHh0jT8tp8q2AqrAwCSt8pCK9t2o3R4UWQj5eYZjd/eg4CwM8fMpagCrM0eaijy/VZZfsDfyWRTnWbI5wuqZQt+vAggYdcN8S14vu2HSwxRduBM4hJw4KcLgagfFAduOUdFeMrRuj9KmB2TwlUH0Hbhqntinm3qEg7Zbjkgh7RhJS8v0r+VTaS3ZBYxOHsJrira5RAvBrxUThU2Kl3thEs6ygFcQedu2W05ClDkgZt2Jp3X6bweuA9D/lpVtmhAbaCzs5mGylGxghHh3r82dUaPRdWyHvnNaHI2Zf8+kSQQh6HxT8B/mI5Txs5f8h37KweJvGvOn0ilGM8P2vxsIw== shailensukul@gmail.com\n'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Network/networkInterfaces/moodleVMVMNic'
        }
      ]
    }
  }

}
@description('Generated from /subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Compute/images/moodleImage')
resource moodleImage 'Microsoft.Compute/images@2023-07-01' = {
  name: 'moodleImage'
  location: 'eastus'
  tags: {
    dept: 'Engineering'
    task: 'Image deployment'
  }
  properties: {
    sourceVirtualMachine: {
      id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/pkr-Resource-Group-hmwob0zdxw/providers/Microsoft.Compute/virtualMachines/pkrvmhmwob0zdxw'
    }
    storageProfile: {
      osDisk: {
        osType: 'Linux'
        osState: 'Generalized'
        diskSizeGB: 30
        managedDisk: {
          id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/pkr-Resource-Group-hmwob0zdxw/providers/Microsoft.Compute/disks/pkroshmwob0zdxw'
        }
        caching: 'ReadWrite'
        storageAccountType: 'Standard_LRS'
      }
      dataDisks: []
      zoneResilient: false
    }
    hyperVGeneration: 'V1'
  }
}
