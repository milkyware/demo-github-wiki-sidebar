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

    "sidebar_content=$sidebarContent" >> $env:GITHUB_OUTPUT
}