
# create a junction to the module folder into the psmodulepath for local development

$ModuleName = "AzureDevopsDataCollector"
$ModulePath = $env:PSModulePath -split ';' | Select-Object -First 1
$Source = Join-Path -Path $ModulePath -ChildPath $Name
$Target = Join-Path -Path $PSScriptRoot -ChildPath $ModuleName
New-Item -ItemType Junction -Path $Source -Value $Target -Force
