# Instrukcja:
## Przygotowanie infrastruktury:
```bash
az deployment group create --resource-group <RESOURCE_GROUP> --template-file infra/main.bicep --parameters sqlAdminUsername='<USERNAME>' sqlAdminPassword='<PASSWORD>' webAppName='<WEB_APP_NAME>' sqlServerName='<SQL_SERVER_NAME>' sqlDatabaseName='<SQL_DATABASE_NAME>'
```

Wypełnij parametry w infra/main.bicep.
Uruchom wdrożenie infrastruktury:
## Wdrożenie aplikacji:

Uruchom skrypt deploy-app.sh:
```bash
bash scripts/deploy-app.sh
```

## Testowanie:
Otwórz aplikację w przeglądarce pod adresem: http://<WEB_APP_NAME>.azurewebsites.net.
Uwagi:
Upewnij się, że masz zainstalowane Azure CLI.
Dodaj dane logowania do Azure SQL jako zmienne środowiskowe w Azure Web App.