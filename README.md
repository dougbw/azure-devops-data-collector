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

```
Install-Module AzureDevopsDataCollector
```

# Pre-requsuites
* Azure Storage Account (for data export)
* PowerBI (for dashboard)

# Usage (inside an AzDo pipeline)

The quickest way to use this is to run it inside a scheduled Azure DevOps pipeline, as the job can consume [predefined variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=azure-devops&tabs=yaml#systemaccesstoken) containing the organization name and api token.

* Create a repo in Azure DevOps with the contents of the **Example** directory
* Create a library variable set named **storage-account-vars** containing the following variables
    * StorageAccountName
    * StorageAccountKey
* Create a pipeline pointing to "azure-pipelines.yml" in your new repo

# Usage (outside an AzDo pipeline)
```
Import-Module AzureDevopsDataCollector
$Params = @{
    Organization = $Organization
    PersonalAccessToken = $PersonalAccessToken
    StorageAccountName = $StorageAccountName
    StorageAccountKey = $StorageAccountKey
}
Invoke-AzDoDataCollector @Params
```

# What data is collected

The data is pulled from the Azure DevOps REST API 

* Projects
    * Pipelines
        * Pipeline runs
    * Environments
        * Deployments
    * Repos
        * Commits
        * Pull requests
* Work Items



