Function New-AzTable {
    [CmdletBinding()]
    
    Param(
        [parameter(Mandatory = $true)]
        [string]
        $connString,

        [parameter(Mandatory = $true)]
        [string]
        $tableName
    )

    # create table
    $storageAccount = [Microsoft.Azure.Cosmos.Table.CloudStorageAccount]::Parse($connString)
    $TableClient = [Microsoft.Azure.Cosmos.Table.CloudTableClient]::new($storageAccount.TableEndpoint, $storageAccount.Credentials)
    $Table = [Microsoft.Azure.Cosmos.Table.CloudTable]$TableClient.GetTableReference($TableName)
    $Table.CreateIfNotExists() | Out-Null
    Return $Table
}