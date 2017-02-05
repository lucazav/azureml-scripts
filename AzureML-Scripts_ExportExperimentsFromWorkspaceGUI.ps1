
# Unblock the downloaded dll file so Windows can trust it.
Unblock-File C:\Install\AzureMLPS\AzureMLPS.dll
# import the PowerShell module into current session
Import-Module C:\Install\AzureMLPS\AzureMLPS.dll



# Get the source workspace
$sourceWorkspace = Get-AmlWorkspace -ConfigFile 'C:\Install\AzureMLPS\config_source.json';

# Define the destination folder of the output files
$destinationFolder = 'c:\Temp\';

# Get all the experiments from the source workspace
$experiments = Get-AmlExperiment -WorkspaceId $sourceWorkspace.WorkspaceId -AuthorizationToken $sourceWorkspace.AuthorizationToken.PrimaryToken

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
    | out-gridview -Title "Experiments to export from the '$($sourceWorkspace.FriendlyName)' workspace" -passthru

# For each selected experiment from the source workspace extract the corresponding experiment graph to a file in JSON format
foreach ($s in $selected) 
{
    $fileName = "$($s.Description.Replace(' ', '_')).json"
    $fullPath = [io.path]::combine($destinationFolder, $fileName);

    if (Test-Path $fullPath) {
        $currentDateTimeToken = Get-Date -format yyyyMMdd_HHmmss;
        $fileName = "$($s.Description.Replace(' ', '_'))_$($currentDateTimeToken).json"
        $fullPath = [io.path]::combine($destinationFolder, $fileName);
    }

    Export-AmlExperimentGraph -ExperimentId $s.ExperimentId -OutputFile $fullPath `
        -WorkspaceId $sourceWorkspace.WorkspaceId -AuthorizationToken $sourceWorkspace.AuthorizationToken.PrimaryToken;
}


