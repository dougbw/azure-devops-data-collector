Function New-AzTableEntities {
    Param(
        [parameter(Mandatory = $true)]
        $Items,

        [parameter(Mandatory = $true)]
        $PartitionKey,

        [parameter(Mandatory = $false)]
        $rowKeyField      
    )

    $Entities = New-Object -TypeName 'System.Collections.ArrayList'
    
    foreach ($item in $Items) {

        if ($PSBoundParameters.ContainsKey('rowKeyField')) {
            $RowKey = $item.($rowKeyField)
        }
        else {
            if ($item.id) {
                $RowKey = $item.id
            }
            else {
                throw "wtf is the rowkey gonna be..."
            }
        }
        $Entity = New-TableStorageRowEntity -PartitionKey $PartitionKey -RowKey $RowKey -Data $Item
        $Entities.Add($Entity) | Out-Null
    }

    return $Entities

}