Function Publish-ToAzureTableStorage {
    Param(
        [parameter(Mandatory = $True)]
        $StorageAccountName,

        [parameter(Mandatory = $True)]
        $StorageAccountKey,

        [parameter(Mandatory = $True)]
        $Collections
    )

    $connString = "DefaultEndpointsProtocol=https;AccountName={0};AccountKey={1}" -f $storageAccountName, $StorageAccountKey

    # group data by table
    $Tables = $collections | Group-Object -Property table
    foreach ($Table in $Tables) {

        # create the table
        $StorageAccountTable = New-AzTable -connString $connString -TableName $Table.Name

        # group data by partition key
        $partitions = $table.group | Group-Object -Property partitionKey
        foreach ($partition in $partitions) {

            # this should never happen...
            if ($partition.Group.Payload.count -eq 0) {
                Write-Warning -verbose "no payload"
                Continue
            }

            # set rowkey field
            $params = @{
                items        = $partition.group.payload
                PartitionKey = $partition.Name
            }
            if (($partition.group.rowKeyField | Select-Object -Unique).count -eq 1) {
                $params.RowKeyField = $partition.group.rowKeyField | Select-Object -Unique
            }

            # create table entities
            $Entities = New-AzTableEntities @params

            # insert in batches
            Add-TableStorageRowBatch -StorageAccountTable $StorageAccountTable -Entities $Entities
        }
    }

}