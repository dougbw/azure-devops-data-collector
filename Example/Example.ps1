$Organization = ""
$PersonalAccessToken = ""
$StorageAccountKey = ""
$StorageAccountName = ""

Import-Module AzureDevopsDataCollector
Import-Module Az

$Params = @{
    Organization = $Organization
    PersonalAccessToken = $PersonalAccessToken
    StorageAccountName = $StorageAccountName
    StorageAccountKey = $StorageAccountKey
}
Invoke-AzDoDataCollector @Params