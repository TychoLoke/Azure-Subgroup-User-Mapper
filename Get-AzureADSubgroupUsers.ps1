# Connect to Azure AD
Connect-AzureAD

# Get the Group Object
$group = Get-AzureADGroup -SearchString "GROUPNAME"

# Create an empty array to store the results
$results = @()

# Get all subgroups within the specified group
$groups = Get-AzureADGroupMember -ObjectId $group.ObjectId -All $true | Where-Object { $_.ObjectType -eq 'Group' }

# Loop through each group
foreach ($g in $groups) {
    # Get all users in the group
    $users = Get-AzureADGroupMember -ObjectId $g.ObjectId -All $true | Where-Object { $_.ObjectType -eq 'User' }
    
    # Loop through each user
    foreach ($u in $users) {
        # Create a custom object to store the group and user display names
        $result = New-Object PSObject
        $result | Add-Member -MemberType NoteProperty -Name "GroupDisplayName" -Value $g.DisplayName
        $result | Add-Member -MemberType NoteProperty -Name "UserDisplayName" -Value $u.DisplayName
        
        # Add the custom object to the results array
        $results += $result
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path "C:\path\output\output.csv" -NoTypeInformation
