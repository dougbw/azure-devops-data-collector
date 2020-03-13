function Split-Batch {
    [cmdletbinding()]
    Param(
        $items,
        $BatchSize = 100
    )

    $counter = [pscustomobject] @{ Value = 0 }
    $groups = $items | Group-Object -Property { [math]::Floor($counter.Value++ / $BatchSize) }

    $batches = New-Object System.Collections.ArrayList 
    foreach ($groups in $groups) {
        $batches.Add($groups.group) | Out-Null
    }
    Write-Verbose -Verbose ("split items into {0} batches" -f $batches.count)
    return , $batches
}