#!/bin/bash

#echo "Clearing namespace"
#sed -i "" "s|\"namespace\": \"\"|\"namespace\": \"\"|" sfdx-project.json

echo "Cleaning previous scratch org..."
sf org delete scratch --no-prompt --target-org ChatterBINGO

echo "Creating new scratch org"
sf org create scratch --definition-file config/project-scratch-def.json --duration-days 10 --alias ChatterBINGO --set-default

echo "Pushing metadata"
sf project deploy start

#echo "Assigning Permissions"
sf org assign permset --name PermSetName

echo "Opening org"
sf org open

echo "Org is set up"