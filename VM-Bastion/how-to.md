
az deployment group what-if \
  --resource-group <your-rg> \
  --template-file main.bicep \
  --parameters adminUsername='test' adminPassword='YourPassword123!'
