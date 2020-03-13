Write-Verbose -Verbose "Installing Az powershell module"
Install-Module Az -Force -AllowClobber
Import-Module Az

Write-Verbose -Verbose "AzureDevopsDataCollector module"
Install-Module AzureDevopsDataCollector -Force
Import-Module AzureDevopsDataCollector

$params = @{
    Organization = Split-Path -leaf $env:SYSTEM_TEAMFOUNDATIONSERVERURI
    PersonalAccessToken = $env:SYSTEM_ACCESSTOKEN
    StorageAccountName = $env:STORAGEACCOUNTNAME
    StorageAccountKey = $env:STORAGEACCOUNTKEY
    ConfigFile = "all"
}
Invoke-AzDoDataCollector @params
