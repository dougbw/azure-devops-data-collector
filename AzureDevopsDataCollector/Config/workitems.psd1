@{
    endpoints = @(
        @{
            name             = "workitems"
            path             = '$BaseUri/_apis/wit/wiql'
            partitionKey     = '$Organization'
            method           = "POST"
            body             = @{
                query = "Select * From WorkItems"
            }
            batchiterator    = @{
                field = "workitems"
                size  = 100
            }
            persistToStorage = $false
            resources        = @(
                @{
                    name         = "workitems"
                    path         = '$BaseUri/_apis/wit/workitemsbatch'
                    iterator     = "value"
                    partitionKey = '$Organization'
                    method       = "post"
                    body         = @{
                        ids = '$($workitems.id)'
                    }
                }
            )
        }
        
    ) 
}