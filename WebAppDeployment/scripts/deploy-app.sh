#!/bin/bash

# Variables
RESOURCE_GROUP="<RESOURCE_GROUP>"
WEB_APP_NAME="<WEB_APP_NAME>"

# Deploy application
echo "Deploying application to Azure Web App..."
az webapp deploy --resource-group $RESOURCE_GROUP --name $WEB_APP_NAME --src-path ../app
echo "Application deployed successfully!"