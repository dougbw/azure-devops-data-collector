@{
    endpoints = @(
        @{
            name         = "projects"
            path         = '$BaseUri/_apis/projects'
            iterator     = "value"
            partitionKey = '$Organization'
            resources    = @( 
                @{
                    name         = "environments"
                    path         = '$BaseUri/$($projects.name)/_apis/distributedtask/environments'
                    partitionKey = '$($projects.name)'
                    iterator     = "value"
                    resources    = @(
                        @{
                            name         = "deployments"
                            path         = '$BaseUri/$($projects.name)/_apis/distributedtask/environments/$($environments.id)/environmentdeploymentRecords'
                            partitionKey = '$($projects.name)'
                            iterator     = "value"
                        }
                    )
                }
                @{
                    name         = "definitions"
                    path         = '$BaseUri/$($projects.name)/_apis/build/definitions'
                    iterator     = "value"
                    partitionKey = '$($projects.name)'
                    resources    = @(
                        @{
                            name         = "builds"
                            path         = '$BaseUri/$($projects.name)/_apis/build/builds'
                            iterator     = "value"
                            partitionKey = '$($projects.name)'
                            queryparams  = @{
                                definitions = '$($definitions.id)'
                            }
                        }
                    )
                }
            )
        }
    ) 
}