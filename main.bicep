param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string

module nsg 'modules/nsg.bicep' = {
  name: 'nsg-${location}'
  params: {
    location: location
  }
}

module vnet 'modules/vnet.bicep' = {
  name: 'vnet-${location}'
  params: {
    location: location
    nsgId: nsg.outputs.nsgId
  }
}

module vm 'modules/vm.bicep' = {
  name: 'vm-${location}'
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    subnetId: vnet.outputs.vmSubnetId
  }
}
