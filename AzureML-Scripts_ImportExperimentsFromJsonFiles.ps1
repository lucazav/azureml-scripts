
# Unblock the downloaded dll file so Windows can trust it.
Unblock-File C:\Install\AzureMLPS\AzureMLPS.dll
# import the PowerShell module into current session
Import-Module C:\Install\AzureMLPS\AzureMLPS.dll


$sourceFolder = 'c:\Temp\';
$destinationWorkspace = Get-AmlWorkspace -ConfigFile 'C:\Install\AzureMLPS\config_destination.json'
$useFileNames = $true;

if (!$useFileNames)
{
    dir "$sourceFolder\*.json" | out-gridview -Title "JSON Files of the Source Experiments" -passthru `
        | foreach { Import-AmlExperimentGraph -InputFile $_.fullname `
                    -WorkspaceId $destinationWorkspace.WorkspaceId -AuthorizationToken $destinationWorkspace.AuthorizationToken.PrimaryToken}
}
else
{
    dir "$sourceFolder\*.json" | out-gridview -Title "JSON Files of the Source Experiments" -passthru `
        | foreach { Import-AmlExperimentGraph -InputFile $_.fullname -NewName $_.BaseName`
                    -WorkspaceId $destinationWorkspace.WorkspaceId -AuthorizationToken $destinationWorkspace.AuthorizationToken.PrimaryToken}
}
