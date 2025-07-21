param location string = 'EastUS'
param sqlAdminUsername string
param sqlAdminPassword string
param webAppName string
param sqlServerName string
param sqlDatabaseName string

resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServerName}/${sqlDatabaseName}'
  location: location
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: '2147483648' // 2 GB
    sku: {
      name: 'S0'
      tier: 'Standard'
      capacity: 10
    }
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: 'Default1' // Assuming a default App Service Plan
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: '14.17'
        }
        {
          name: 'DB_SERVER'
          value: sqlServerName
        }
        {
          name: 'DB_NAME'
          value: sqlDatabaseName
        }
        {
          name: 'DB_USER'
          value: sqlAdminUsername
        }
        {
          name: 'DB_PASSWORD'
          value: sqlAdminPassword
        }
      ]
    }
  }
}
