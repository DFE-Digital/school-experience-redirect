token=$(az account get-access-token | jq -r .accessToken)
subscriptionId=$(az account show | jq -r .id)

curl -X GET --header "Authorization: Bearer $token" "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$GROUPNAME/providers/Microsoft.Web/sites/$SITENAME/config/web?api-version=2018-02-01" -o response.json
echo 'the initial response is ....'
cat response.json

jq '.properties.ipSecurityRestrictions = [{"ipAddress": "'$(curl -s https://api.ipify.org)'/32","action": "Allow","tag": "Default","priority": 100,"name": "allowed access"}]' response.json > updatedResponse.json

echo 'the updated response is...'
cat updatedResponse.json

curl -X PUT -H "Content-Type: application/json" -d @updatedResponse.json --header "Authorization: Bearer $token" "https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$GROUPNAME/providers/Microsoft.Web/sites/$SITENAME/config/web?api-version=2018-02-01" 

