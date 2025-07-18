param location string = resourceGroup().location
param adminUsername string
@secure()
param adminPassword string
param domainName string = 'contoso.com'
@secure()
param safeModePassword string

resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: 'vnet-ad'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-ad'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: 'pip-ad-vm'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2022-01-01' = {
  name: 'nic-ad-vm'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIP.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: 'ad-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: 'ad-vm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

resource cse 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: 'ad-vm/Install-ADDS'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: concat('powershell -ExecutionPolicy Unrestricted -Command "', '''
        Install-WindowsFeature AD-Domain-Services -IncludeManagementTools;
        Import-Module ADDSDeployment;
        Install-ADDSForest -DomainName ''', domainName, ''' -SafeModeAdministratorPassword (ConvertTo-SecureString ''', safeModePassword, ''' -AsPlainText -Force) -Force;

        # Validation
        if ((Get-WindowsFeature AD-Domain-Services).InstallState -eq "Installed") {
            Write-Output "AD DS role installed.";
        } else {
            Write-Output "ERROR: AD DS role NOT installed.";
            exit 1;
        }

        try {
            $domain = Get-ADDomain;
            Write-Output "Domain promotion succeeded. Domain: $($domain.Name)";
        }
        catch {
            Write-Output "ERROR: Domain promotion FAILED.";
            exit 1;
        }
      ''', '"')
    }
  }
  dependsOn: [
    vm
  ]
}
