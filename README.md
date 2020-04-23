# azure-devops-data-collector

This module pulls data from the [Azure DevOps REST API](https://docs.microsoft.com/en-us/rest/api/azure/devops/?view=azure-devops-rest-5.1) and publishes to Azure table storage. The data can then be modeled in PowerBI into pretty graphs and stuff.

![Example dashboard](https://github.com/dougbw/azure-devops-data-collector/blob/master/Example/example-dashboard-1.png?raw=true)

This can provide a holistic view across an organization of:
- Resource usage (how many repos, projects, pipelines, etc)
- Development activity (commits, pull requests)
- Pipeline success rate/duration
- Deployments to environments

# Build status
[![Build Status](https://dev.azure.com/dougbw/Azure/_apis/build/status/dougbw.azure-devops-data-collector?branchName=master)](https://dev.azure.com/dougbw/Azure/_build/latest?definitionId=14&branchName=master)

# Installation

This module can be installed from the [PowerShell Gallery](https://www.powershellgallery.com/packages/AzureDevopsDataCollector)

```
Install-Module AzureDevopsDataCollector
```

# Pre-requsuites
* [Azure PowerShell Module](https://docs.microsoft.com/en-us/powershell/azure/new-azureps-module-az)
* Azure Storage Account 
* [PowerBI Desktop](https://powerbi.microsoft.com/en-us/desktop/)


# Usage (inside an AzDo pipeline)

The quickest way to use this is to run it inside a scheduled Azure DevOps pipeline, as the job can consume [predefined variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml#systemaccesstoken) containing the organization name and api token. This pipeline can then be triggered on a scheduled using the built-in [pipeline scheduling](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/scheduled-triggers?view=azure-devops&tabs=yaml) feature.

* Create a repo in Azure DevOps and copy the following files into it from the **Example** directoy:
    * [azure-pipelines.yml](https://github.com/dougbw/azure-devops-data-collector/blob/master/Example/azure-pipelines.yml)
    * [Start-Pipeline.ps1](https://github.com/dougbw/azure-devops-data-collector/blob/master/Example/Start-Pipeline.ps1)
* Create a library variable set named **storage-account-vars** containing the following variables
    * StorageAccountName
    * StorageAccountKey
* Create a pipeline pointing to "azure-pipelines.yml" in your new repo

# Usage (outside an AzDo pipeline)
```
Import-Module AzureDevopsDataCollector
Import-Module Az
$Params = @{
    Organization = $Organization
    PersonalAccessToken = $PersonalAccessToken
    StorageAccountName = $StorageAccountName
    StorageAccountKey = $StorageAccountKey
}
Invoke-AzDoDataCollector @Params
```

# Using the dashboard

Open the powerbi template file from this repo. Upon opening it *should* prompt for a storage account name and key. Save it as a powerbi report file (.pbix) once you have completed the initial data load.

This template contains the data model and relationships between the data (E.g commits to repos, deployments to environments) so use this as a starting point and delete any pages / visualizations you don't want.


# What data is collected

The data which is currently pulled from the Azure DevOps REST API. The module *can* be extended to collect data from other api endpoints through [configuration files](https://github.com/dougbw/azure-devops-data-collector/tree/master/AzureDevopsDataCollector/Config) although I have not documented the schema for this yet.

```
* Projects
    * Pipelines
        * Pipeline runs
    * Environments
        * Deployments
    * Repos
        * Commits
        * Pull requests
* Work Items
```


