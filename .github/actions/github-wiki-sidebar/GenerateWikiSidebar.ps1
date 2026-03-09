<#
.SYNOPSIS
Generates a sidebar for a GitHub wiki.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Separator,
    [Parameter()]
    [string[]]$Exclude,
    [Parameter()]
    [string[]]$Order,
    [Parameter()]
    [string]$OutputPath
)
begin
{
    $InformationPreference = 'Continue'
    if ($env:RUNNER_DEBUG -eq 'true')
    {
        $DebugPreference = 'Continue'
        $VerbosePreference = 'Continue'
    }
}
process
{
    $files = git ls-files

    Write-Debug "Sorting files"
    $files = $files | Sort-Object {
        $priorityIndex = $Priority.IndexOf($_)
        if ($priorityIndex -ge 0) {
            return $priorityIndex
        }
        return [int]::MaxValue
    }, $_

    "sidebar_content=$sidebarContent" >> $env:GITHUB_OUTPUT
}