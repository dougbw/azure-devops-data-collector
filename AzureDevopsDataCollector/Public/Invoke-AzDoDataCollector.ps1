Function Invoke-AzDoDataCollector {
    Param(
        [parameter(Mandatory = $true)]
        $Organization,

        [parameter(Mandatory = $true)]
        $PersonalAccessToken,

        [parameter(Mandatory = $true)]
        $StorageAccountName,
    
        [parameter(Mandatory = $true)]
        $StorageAccountKey,

        [parameter(Mandatory = $False)]
        [ValidateSet(
            "all",
            "builds",
            "repos",
            "workitems"
        )]
        $ConfigFile = "all"
    
    )

    try {
        $ConfigFileName = "{0}.psd1" -f $ConfigFile
        $ConfigDir = Join-path -Path (Split-path -path $PSScriptRoot -Parent) -ChildPath "Config"
        $ConfigFilePath = Join-Path -path $ConfigDir -ChildPath $ConfigFileName

        $config = Import-PowerShellDataFile -Path $ConfigFilePath
        $Auth = Get-AzdoAuthHeaders -Organization $Organization -PersonalAccessToken $PersonalAccessToken

        # get data
        $collections = @()
        $collections += Get-AzDoData -endpoints $config.endpoints -Auth $Auth

        # publish data
        Publish-ToAzureTableStorage -Collections $collections -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey

    }
    catch {
        throw $_
    }

}

