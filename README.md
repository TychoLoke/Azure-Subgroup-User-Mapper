# Azure AD Group and User Export Script

This PowerShell script retrieves a specified group from Azure Active Directory (AD) using an exact display name match, extracts all subgroups and users within those subgroups, and exports the information to a CSV file.

## Requirements

- Azure AD Module installed in your PowerShell environment.
- Proper authentication and permissions to read group and user information from Azure AD.
- Update the output path in the script with the correct file path where you want to save the CSV file.

## How to Use

1. **Connect to Azure AD:** The script first establishes a connection to Azure AD.
2. **Specify the Group:** Replace `"GROUPNAME"` in the script with the exact display name of the group you want to query. The script validates that a single group with that display name exists.
3. **Run the Script:** Execute the script in a PowerShell environment.

## What the Script Does

- Retrieves the specified group from Azure AD using an exact display name filter and stops with an error if no group or multiple groups are found.
- Initializes an empty array to store the results.
- Retrieves all subgroups within the specified group, filtering only objects of type 'Group'.
- Loops through each subgroup and user, creating a custom object that stores the display names of the subgroup and user.
- Exports the results to a CSV file.

## Output

The script creates a CSV file containing two columns: `GroupDisplayName` and `UserDisplayName`. Each row represents a user in a subgroup, displaying the display names of the subgroup and user.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- Thanks to the Azure team for providing the necessary cmdlets and documentation.
