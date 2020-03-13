@{
    endpoints = @(
        @{
            name             = "workitems"
            path             = '$BaseUri/_apis/wit/wiql'
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
                    name         = "teams"
                    path         = '$BaseUri/_apis/projects/$($projects.name)/teams'
                    iterator     = "value"
                    partitionKey = '$($projects.name)'
                }
                @{
                    name         = "repositories"
                    path         = '$BaseUri/$($projects.name)/_apis/git/repositories'
                    iterator     = "value"
                    partitionKey = '$($projects.name)'
                    customFields = @{
                        repoPath = '$($projects.name + "/" + $item.name)'
                    }
                    resources    = @(
                        @{
                            name         = "pullrequests"
                            path         = '$BaseUri/$($projects.name)/_apis/git/repositories/$($repositories.id)/pullrequests'
                            iterator     = "value"
                            partitionKey = '$($projects.name)'
                            rowKey       = "pullRequestId"
                            queryParams  = @{
                                'searchCriteria.status' = "all"
                            }
                        }
                        @{
                            name         = "commits"
                            path         = '$BaseUri/$($projects.name)/_apis/git/repositories/$($repositories.id)/commits'
                            iterator     = "value"
                            partitionKey = '$($projects.name)'
                            rowKey       = "commitId"
                            customFields = @{
                                repoId   = '$($repositories.id)'
                                repoName = '$($repositories.name)'
                                id       = '$($item.commitId)'
                            }
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