param location string
param nsgId string

var vnetName = 'test-vnet'
var vmSubnetName = 'vm-subnet'
var bastionSubnetName = 'AzureBastionSubnet'
var addressPrefix = '10.0.0.0/16'
var vmSubnetPrefix = '10.0.1.0/24'
var bastionSubnetPrefix = '10.0.255.0/27'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: vmSubnetName
        properties: {
          addressPrefix: vmSubnetPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
      {
        name: bastionSubnetName
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
    ]
  }
}

output vmSubnetId string = vnet.properties.subnets[0].id
output bastionSubnetId string = vnet.properties.subnets[1].id
