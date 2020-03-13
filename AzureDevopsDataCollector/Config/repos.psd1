@{
    endpoints = @(
        @{
            name         = "projects"
            path         = '$BaseUri/_apis/projects'
            iterator     = "value"
            partitionKey = '$Organization'
            resources    = @( 
                @{
                    name         = "repositories"
                    path         = '$BaseUri/$($projects.name)/_apis/git/repositories'
                    iterator     = "value"
                    partitionKey = '$($projects.name)'
                    customFields = @{
                        repoPath = '$($projects.name)/$($item.name)'
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
                                repoId = '$($repositories.id)'
                            }
                        }
                    )
                }
            )
        }
    ) 
}