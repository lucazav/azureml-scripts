
# Unblock the downloaded dll file so Windows can trust it.
Unblock-File C:\Install\AzureMLPS\AzureMLPS.dll
# import the PowerShell module into current session
Import-Module C:\Install\AzureMLPS\AzureMLPS.dll


# Define the folder containing all the experiment json files
$sourceFolder = 'c:\Temp\';

# Get the destination workspace
$destinationWorkspace = Get-AmlWorkspace -ConfigFile 'C:\Install\AzureMLPS\config_destination.json'

# Define a boolean variable. If true, the experiments will be imported using the file name.
# If false, they will be imported using the experiment original name
$useFileNames = $true;

# Pop out the gui to select one or more experiment json files. Then import them in the destination workspace
if (!$useFileNames)
{
    dir "$sourceFolder\*.json" | out-gridview -Title "JSON Files of the Source Experiments" -passthru `
        | foreach { Import-AmlExperimentGraph -InputFile $_.fullname -Location $destinationWorkspace.Region `
                    -WorkspaceId $destinationWorkspace.WorkspaceId -AuthorizationToken $destinationWorkspace.AuthorizationToken.PrimaryToken}
}
else
{
    dir "$sourceFolder\*.json" | out-gridview -Title "JSON Files of the Source Experiments" -passthru `
        | foreach { Import-AmlExperimentGraph -InputFile $_.fullname -NewName $_.BaseName -Location $destinationWorkspace.Region `
                    -WorkspaceId $destinationWorkspace.WorkspaceId -AuthorizationToken $destinationWorkspace.AuthorizationToken.PrimaryToken}
}
