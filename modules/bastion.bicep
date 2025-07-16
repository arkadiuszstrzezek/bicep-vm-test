param location string
param vnetId string
param subnetName string = 'AzureBastionSubnet'

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'bastion-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: 'myBastionHost'
  location: location
  sku: {
    name: 'Basic' // lub 'Standard' jeśli chcesz pełny Bastion z funkcjami scaling
  }
  properties: {
    ipConfigurations: [
      {
        name: 'bastionIPConfig'
        properties: {
          subnet: {
            id: '${vnetId}/subnets/${subnetName}'
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

output bastionId string = bastion.id
