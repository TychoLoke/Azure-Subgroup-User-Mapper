param(
    [Parameter(Mandatory = $true)]
    [string]$GroupName,

    [string]$OutputPath = "C:\Temp\AzureAD-SubgroupUsers.csv",

    [switch]$ExactMatch
)

function Initialize-PowerShellAdminHelpers {
    $moduleName = "PowerShellAdminHelpers"

    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        $installerPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Install-PowerShellAdminHelpers.ps1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TychoLoke/powershell-admin-helpers/main/Install-PowerShellAdminHelpers.ps1" -OutFile $installerPath
        & $installerPath
    }

    Import-Module -Name $moduleName -Force -ErrorAction Stop
}

Initialize-PowerShellAdminHelpers
Ensure-OutputDirectory -Path (Split-Path -Path $OutputPath -Parent)
Ensure-Module -ModuleName "Microsoft.Graph.Groups"
Ensure-Module -ModuleName "Microsoft.Graph.Users"

Connect-GraphWithScopes -Scopes @("Group.Read.All", "User.Read.All")

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

$results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "Exported $($results.Count) rows to $OutputPath"

if (Get-MgContext) {
    Disconnect-MgGraph | Out-Null
}
