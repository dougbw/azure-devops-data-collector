Function Get-AzDoData {
    [CmdletBinding()]
    Param(

        [parameter(Mandatory = $true)]
        $endpoints,

        [parameter(Mandatory = $true)]
        $Auth

    )

    $BaseUri = $Auth.BaseUri

    foreach ($endpoint in $endpoints) {

        # debug
        switch ($endpoint.name) {
            "builds" {
                Write-Debug "builds"
            }
            "workitemsbatch" {
                Write-Debug "workitemsbatch"
            }
            "repositories" {
                Write-Debug "repositories"
            }
        }

        $requestParams = @{
            Uri     = Expand-String -String $endpoint.path
            Headers = $Auth.Headers
        }

        switch ($endpoint.method) {

            "post" {
                $requestParams.Method = "post"

                if ($endpoint.body) {
                    $Body = @{ }
                    foreach ($bodyProperty in $endpoint.body.GetEnumerator()) {
                        $Body.($bodyProperty.Name) = (Expand-String -String $bodyProperty.Value)
                    }
                    $requestParams.Body = $Body | ConvertTo-Json
                }
            }

            default {

                # add query params
                if ($endpoint.queryparams) {
                    $requestParams.Body = @{ }
                    foreach ($queryparam in $endpoint.queryparams.GetEnumerator()) {
                        $requestParams.Body.($queryparam.Name) = (Expand-String -String $queryparam.Value)
                    }
                }

            }
        }
            
            
        try {
            Write-Verbose -Verbose ("getting '{0}' from '{1}'" -f $endpoint.name, $requestParams.Uri)
            $response = Invoke-RestMethod @requestParams
        }
        catch {
            throw $_
        }


        $data = @{ }

        if ($endpoint.iterator) {
            $items = $response.$($endpoint.iterator)
            Write-Verbose -Verbose ("{0} contains {1} items" -f $endpoint.name, $items.count)
            $data.payload = $items

            # process custom fields
            if ($endpoint.customFields) {
                foreach ($customField in $endpoint.customFields.GetEnumerator()) {
                    foreach ($item in $data.payload) {
                        $item | Add-Member -MemberType NoteProperty -Name $customField.Name -Value (Expand-String -String $customField.Value)
                    }
                }
            }
        }
        elseif ($endpoint.batchiterator) {
            #$items = Invoke-Expression "`$response.$($endpoint.batchiterator.field)"
            $items = $response.$($endpoint.batchiterator.field)
            $batches = Split-Batch -items $items -BatchSize $endpoint.batchiterator.size
            $data.payload = $batches
        }
        else {
            Write-Verbose -Verbose ("items = {0}" -f $response.count)
            $data.payload = $response

            # add custom fields
            if ($endpoint.customFields) {
                foreach ($customField in $endpoint.customFields.GetEnumerator()) {
                    $data.payload | Add-Member -MemberType NoteProperty -Name $customField.Name -Value (Expand-String -String $customField.Value)
                }
            }

        }

        $data.table = $endpoint.name
        $data.partitionKey = Expand-String -String $endpoint.partitionKey
        if ($endpoint.rowKey) {
            $data.rowKeyField = $endpoint.rowKey
        }
            
        # return data to caller
        if ($endpoint.persistToStorage -ne $false) {
            if ($data.payload.count -ne 0) {
                $data
            }
        }

        # process child resources
        if ($endpoint.resources) {
            foreach ($item in $data.payload) {
                # enable child resources to reference properties from the current object
                Set-Variable -Name $endpoint.name -Value $item -Scope Script

                Get-AzDoData -Auth $Auth -endpoints $endpoint.resources
            }
        }
            
    }
    
}