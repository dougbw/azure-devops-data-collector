function Add-TableStorageRowBatch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $StorageAccountTable,

        [Parameter(Mandatory = $true)]
        [PSCustomObject]
        $Entities

    )
    try {

    
        $batches = @{ }
        Write-Debug ("entity batch contains {0} items" -f $Entities.count)
        foreach ($Entity in $Entities) {

            if ($batches.ContainsKey($Entity.PartitionKey) -eq $false) {
                $batches.Add($Entity.PartitionKey, (New-Object Microsoft.Azure.Cosmos.Table.TableBatchOperation))
            }

            $batchOperation = $batches[$entity.PartitionKey]
            $batchOperation.InsertOrMerge($entity)

            if ($batchOperation.Count -eq 100) {
                Write-Verbose ("Inserting '{0}' rows to table storage. Table = '{1}', PartitionKey = '{2}'" -f $batchOperation.count, $StorageAccountTable.name, $Entity.PartitionKey)
                $StorageAccountTable.ExecuteBatch($batchOperation) | Out-Null
                $batches[$entity.PartitionKey] = (New-Object Microsoft.Azure.Cosmos.Table.TableBatchOperation)
            }
        }

        foreach ($batch in $batches.GetEnumerator()) {
            if ($batch.value.Count -gt 0) {
                Write-Verbose -Verbose ("Inserting '{0}' rows to table storage. Table = '{1}', PartitionKey = '{2}'" -f $batch.value.count, $StorageAccountTable.name, $batch.Name)
                $StorageAccountTable.ExecuteBatch($batch.Value) | Out-Null
            }
        }

    }
    catch {
        Write-Warning $_
        throw $_
    }
}
