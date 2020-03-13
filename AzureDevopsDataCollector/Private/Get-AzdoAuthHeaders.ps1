Function Get-AzdoAuthHeaders {
    [cmdletbinding()]
    Param(
    
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Organization,
            
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $PersonalAccessToken,
    
        [Parameter(Mandatory = $False)]
        [ValidateSet(
            "5.1",
            "6.0-preview"
        )]
        [string]
        $ApiVersion = "6.0-preview"
    
    )
    
    $BaseUri = "https://dev.azure.com/{0}" -f $Organization
    $AuthBase64 = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(" :$PersonalAccessToken"))
    $Headers = @{
        Authorization  = "Basic $AuthBase64"
        "Content-Type" = "application/json; charset=utf-8"
        Accept         = "application/json; api-version=$ApiVersion"
    }
    Return [pscustomobject]@{
        BaseUri = $BaseUri
        Headers = $Headers
    
    }
    
}