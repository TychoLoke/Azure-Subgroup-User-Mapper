param(
    [Parameter(Mandatory = $true)]
    [string]$GroupName,

    [string]$OutputPath = "C:\Temp\AzureAD-SubgroupUsers.csv",

    [switch]$ExactMatch
)

function Ensure-Module {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName
    )

    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Install-Module -Name $ModuleName -Scope CurrentUser -Force
    }

    Import-Module $ModuleName -ErrorAction Stop
}

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ($outputDirectory -and -not (Test-Path -Path $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

Ensure-Module -ModuleName "Microsoft.Graph.Groups"
Ensure-Module -ModuleName "Microsoft.Graph.Users"

Connect-MgGraph -Scopes @("Group.Read.All", "User.Read.All") -NoWelcome

$groups = Get-MgGroup -All -Property "id,displayName"
$group = if ($ExactMatch) {
    $groups | Where-Object { $_.DisplayName -eq $GroupName } | Select-Object -First 1
} else {
    $groups | Where-Object { $_.DisplayName -like "*$GroupName*" } | Select-Object -First 1
}

if (-not $group) {
    throw "No Microsoft Entra group found for search string '$GroupName'."
}

$results = @()
$childGroups = Get-MgGroupMember -GroupId $group.Id -All | Where-Object {
    $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.group'
}

foreach ($g in $childGroups) {
    $users = Get-MgGroupMember -GroupId $g.Id -All | Where-Object {
        $_.AdditionalProperties['@odata.type'] -eq '#microsoft.graph.user'
    }

    foreach ($u in $users) {
        $results += [PSCustomObject]@{
            ParentGroupDisplayName = $group.DisplayName
            GroupDisplayName       = $g.AdditionalProperties['displayName']
            UserDisplayName        = $u.AdditionalProperties['displayName']
            UserPrincipalName      = $u.AdditionalProperties['userPrincipalName']
        }
    }
}

$results | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Host "Exported $($results.Count) rows to $OutputPath"
Disconnect-MgGraph | Out-Null
