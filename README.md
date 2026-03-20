# Azure AD Group and User Export Script

This PowerShell script retrieves a specified group from Azure Active Directory (Azure AD), extracts all subgroups and users within those subgroups, and exports the information to a CSV file.

## Requirements

- AzureAD module installed in your PowerShell environment.
- Proper authentication and permissions to read group and user information from Azure AD.
- A group name to search for and a writable output path.

## How to Use

1. **Connect to Azure AD:** The script first establishes a connection to Azure AD.
2. **Specify the Group:** Pass the group name using the `-GroupName` parameter.
3. **Choose an Output Path:** Optionally override the default CSV path with `-OutputPath`.
4. **Run the Script:** Execute the script in a PowerShell environment.

```powershell
.\Get-AzureADSubgroupUsers.ps1 -GroupName "Your Group Name" -OutputPath "C:\Temp\AzureAD-SubgroupUsers.csv"
```

## What the Script Does

- Retrieves the specified group from Azure AD.
- Initializes an empty array to store the results.
- Retrieves all subgroups within the specified group, filtering only objects of type 'Group'.
- Loops through each subgroup and user, creating a custom object that stores the display names of the subgroup and user.
- Exports the results to a CSV file.

## Output

The script creates a CSV file containing two columns: `GroupDisplayName` and `UserDisplayName`. Each row represents a user in a subgroup, displaying the display names of the subgroup and user.

## Notes

- This script currently uses the legacy `AzureAD` module because that is what the implementation was originally built around.
- If you are standardizing on Microsoft Graph PowerShell, treat this repository as a legacy utility and test it before production use.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Azure team for providing the necessary cmdlets and documentation.
