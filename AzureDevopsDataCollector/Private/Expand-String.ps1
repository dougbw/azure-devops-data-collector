Function Expand-String {
    [cmdletbinding()]
    Param(
        $String
    )

    $ExpressionPattern = '^\$\(.*\)$'

    if ($String -is [string]) {
        if ($String -match $ExpressionPattern) {
            Write-Debug ("Expand-String: String '{0}' is expression" -f $String)
            $result = Invoke-Expression $String
        }
        else {
            Write-Debug ("Expand-String: String '{0}' is string" -f $String)
            $result = $ExecutionContext.InvokeCommand.ExpandString($String)
        }
    }
    else {
        Write-Debug ("Expand-String: input is not a string, ignoring" -f $String)
        $result = $String
    }

    Return $result

}
