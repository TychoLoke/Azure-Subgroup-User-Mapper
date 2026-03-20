param(
    [Parameter(Mandatory = $true)]
    [string]$GroupName,

    [string]$OutputPath = "C:\Temp\AzureAD-SubgroupUsers.csv"
)

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

Connect-AzureAD

$group = Get-AzureADGroup -SearchString $GroupName | Select-Object -First 1
if (-not $group) {
    throw "No Azure AD group found for search string '$GroupName'."
}

$results = @()
$groups = Get-AzureADGroupMember -ObjectId $group.ObjectId -All $true | Where-Object { $_.ObjectType -eq 'Group' }

foreach ($g in $groups) {
    $users = Get-AzureADGroupMember -ObjectId $g.ObjectId -All $true | Where-Object { $_.ObjectType -eq 'User' }

    foreach ($u in $users) {
        $results += [PSCustomObject]@{
            GroupDisplayName = $g.DisplayName
            UserDisplayName  = $u.DisplayName
        }
    }
}

$results | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Host "Exported $($results.Count) rows to $OutputPath"
