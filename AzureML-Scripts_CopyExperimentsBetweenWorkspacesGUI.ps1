
# Unblock the downloaded dll file so Windows can trust it.
Unblock-File C:\Install\AzureMLPS\AzureMLPS.dll
# import the PowerShell module into current session
Import-Module C:\Install\AzureMLPS\AzureMLPS.dll

# Get the source and destination workspaces
$sourceWorkspace = Get-AmlWorkspace -ConfigFile 'C:\Install\AzureMLPS\config_source.json'
$destinationWorkspace = Get-AmlWorkspace -ConfigFile 'C:\Install\AzureMLPS\config_destination.json'

# Get all the experiments from the source workspace
$experiments = Get-AmlExperiment -Location $sourceWorkspace.Region -WorkspaceId $sourceWorkspace.WorkspaceId -AuthorizationToken $sourceWorkspace.AuthorizationToken.PrimaryToken

# Create an empty collection to fill with selected experiment attributes
$coll = New-Object System.Collections.ArrayList

# For each experiment add an item with the selected columns
foreach ($e in $experiments) 
{
    $item = New-Object System.Object

    $item | Add-Member -NotePropertyName "Description" -NotePropertyValue $e.Description;

    $app = [regex]::matches($e.Etag, "'(.*?)'");
    $dt = [System.Web.HttpUtility]::UrlDecode($app.Groups[1].Value).Replace('T', ' ').Replace('Z', '').Substring(0,19);
    $item | Add-Member -NotePropertyName "UTC_DateTime" -NotePropertyValue $dt;

    $item | Add-Member -NotePropertyName "Creator" -NotePropertyValue $e.Creator;
    $item | Add-Member -NotePropertyName "Summary" -NotePropertyValue $e.Summary;
    $item | Add-Member -NotePropertyName "ExperimentId" -NotePropertyValue $e.ExperimentId;

    $coll.Add($item);
}

# Pop out the gui to select one or more experiment from the source workspace
$selected = $coll | sort-object UTC_DateTime -desc `
    | out-gridview -Title "Experiments to copy from the '$($sourceWorkspace.FriendlyName)' to the '$($destinationWorkspace.FriendlyName)' workspace" -passthru

# Copy each selected experiment from the source workspace to the destination one
foreach ($s in $selected) 
{
    try
    {
        Copy-AmlExperiment -WorkspaceId $sourceWorkspace.WorkspaceId -Location $sourceWorkspace.Region -AuthorizationToken $sourceWorkspace.AuthorizationToken.PrimaryToken -ExperimentId $s.ExperimentId `
            -DestinationLocation $destinationWorkspace.Region -DestinationWorkspaceId $destinationWorkspace.WorkspaceId -DestinationWorkspaceAuthorizationToken $destinationWorkspace.AuthorizationToken.PrimaryToken
    }
    catch
    {
        Write-host "Exception caught on copying the experiment '$($s.Description)'" -ForegroundColor Yellow
        Write-Host $_.Exception.Message -ForegroundColor Yellow
    }
}


