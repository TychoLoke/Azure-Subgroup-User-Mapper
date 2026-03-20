# Microsoft Entra Group and User Export Script

This PowerShell script retrieves a specified group from Microsoft Entra ID, extracts child groups and users within those groups, and exports the information to a CSV file.

## Requirements

- `Microsoft.Graph.Groups` and `Microsoft.Graph.Users` modules installed in your PowerShell environment.
- Proper authentication and permissions to read group and user information from Microsoft Entra ID.
- A group name to search for and a writable output path.

## How to Use

1. **Authenticate to Microsoft Graph:** The script connects interactively with delegated read scopes.
2. **Specify the Group:** Pass the group name using the `-GroupName` parameter.
3. **Choose an Output Path:** Optionally override the default CSV path with `-OutputPath`.
4. **Use Exact Matching if Needed:** Add `-ExactMatch` if you want the display name match to be exact.
5. **Run the Script:** Execute the script in a PowerShell environment.

```powershell
.\Get-AzureADSubgroupUsers.ps1 -GroupName "Your Group Name" -OutputPath "C:\Temp\AzureAD-SubgroupUsers.csv"
```

## What the Script Does

- Retrieves the specified group from Microsoft Entra ID.
- Initializes an empty array to store the results.
- Retrieves all child groups within the specified group.
- Loops through each child group and user, exporting the parent group, child group, display name, and UPN.
- Exports the results to a CSV file.

## Output

The script creates a CSV file containing `ParentGroupDisplayName`, `GroupDisplayName`, `UserDisplayName`, and `UserPrincipalName`.

## Notes

- This script now uses Microsoft Graph PowerShell instead of the legacy AzureAD module.
- If the group name is ambiguous, use `-ExactMatch` to avoid selecting the wrong group.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to the Azure team for providing the necessary cmdlets and documentation.
