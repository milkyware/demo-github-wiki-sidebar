<#
.SYNOPSIS
Generates a sidebar for a GitHub wiki.
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$OutputFile,

    [Parameter(Mandatory = $true)]
    [string]$RootFileName,

    [Parameter(Mandatory = $true)]
    [string[]]$ImageExtensions,

    [Parameter(Mandatory = $false)]
    [string]$LinkPrefix,

    [Parameter(Mandatory = $false)]
    [string]$LinkSuffix,

    [Parameter(Mandatory = $false)]
    [string[]]$Exclude,

    [Parameter(Mandatory = $false)]
    [string[]]$Order,

    [Parameter(Mandatory = $false)]
    [bool]$UsePageTitle,

    [Parameter(Mandatory = $false)]
    [bool]$DryRun
)

# Get all markdown files, excluding the output file itself
$files = Get-ChildItem -Filter *.md -Recurse | Where-Object { $_.Name -ne $OutputFile }

# Filter files
$filteredFiles = @()
foreach ($file in $files)
{
    $shouldExclude = $false
    # Exclude based on name
    if ($Exclude -contains $file.Name)
    {
        $shouldExclude = $true
    }
    # Exclude based on image extensions
    if ($ImageExtensions -contains $file.Extension)
    {
        $shouldExclude = $true
    }
    if (-not $shouldExclude)
    {
        $filteredFiles += $file
    }
}

# Order files
$orderedFiles = @()
if ($Order.Length -gt 0)
{
    foreach ($fileName in $Order)
    {
        $foundFile = $filteredFiles | Where-Object { $_.Name -eq $fileName }
        if ($foundFile)
        {
            $orderedFiles += $foundFile
        }
    }
    # Add remaining files
    $remainingFiles = $filteredFiles | Where-Object { $Order -notcontains $_.Name }
    $orderedFiles += $remainingFiles
}
else
{
    $orderedFiles = $filteredFiles
}

# Generate sidebar content
$sidebarContent = ""
if ($RootFileName)
{
    $sidebarContent += "* [$RootFileName]($LinkPrefix/$LinkSuffix)`n"
}

foreach ($file in $orderedFiles)
{
    $fileNameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $linkName = $fileNameWithoutExtension
    if ($UsePageTitle)
    {
        $firstLine = Get-Content $file.FullName -TotalCount 1
        if ($firstLine)
        {
            $linkName = $firstLine.TrimStart('#').Trim()
        }
    }
    
    $link = "[$linkName]($LinkPrefix$fileNameWithoutExtension$LinkSuffix)".Replace('\', '/')
    $sidebarContent += "* $link`n"
}

# Output or write file
if ($DryRun)
{
    Write-Output "Generated Sidebar Content:"
    Write-Output $sidebarContent
}
else
{
    $outputPath = Join-Path $WikiPath $OutputFile
    Set-Content -Path $outputPath -Value $sidebarContent
    Write-Output "Successfully generated sidebar to $outputPath"
}

# Set output
"sidebar-content=$sidebarContent" | Out-File -FilePath $env:GITHUB_OUTPUT -Encoding utf8 -Append