targetScope='resourceGroup'

param resourceGroupName string = resourceGroup().name
param resourceGroupLocation string = resourceGroup().location
param dbdaminLogin string = 'dbadmin'
param dbName string = 'moodledb20402'

@description('Create the virtual network')
resource moodlevirtualnetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: 'moodlevirtualnetwork'
  location: @resourceGroupLocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'moodlesubnet'
      //id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Network/virtualNetworks/moodlevirtualnetwork/subnets/moodlesubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'moodledbsubnet'
        // id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Network/virtualNetworks/moodlevirtualnetwork/subnets/moodledbsubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'Microsoft.DBforMySQL/flexibleServers'
              id: '/subscriptions/ac71096c-a101-4272-8d7e-5662e3778cb1/resourceGroups/moodleRG/providers/Microsoft.Network/virtualNetworks/moodlevirtualnetwork/subnets/moodledbsubnet/delegations/Microsoft.DBforMySQL/flexibleServers'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleServers'
              }
              type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

@description('Create the database')
resource moodledb 'Microsoft.DBforMySQL/flexibleServers@2023-06-30' = {
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    administratorLogin: @dbdaminLogin
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
  location: @resourceGroupLocation
  tags: {
    require_secure_transport: 'OFF'
  }
  name: @dbName
}
