# azureml-scripts
## Useful PowerShell scripts to manage your Azure Machine Learning stuff in a simply way.

These scripts use the *PowerShell Module for Azure Machine Learning Studio & Web Services* you can download from here:

[PowerShell Module for Azure Machine Learning Studio & Web Services](https://github.com/hning86/azuremlps)

Following a brief description of each script.



* **AzureML-Scripts_CopyExperimentsBetweenWorkspacesGUI.ps1**
After you modify the full path of your source and destination workspace config files, the script will pop out a grid view window containing all the source workspace experiments. You can choose one or more experiments (holding down the CTRL key) and then, pressing the OK button, the experiments will be copied in the destination workspace.
Sometimes the transfer using the GUI may fail for some experiments. In that case, exporting those experiments in json files and than importing them in the destination workspace using the following scripts will solve the issue.

* **AzureML-Scripts_ExportExperimentsFromWorkspaceGUI.ps1**
After you modify the full path of your source and destination workspace config files, the script will pop out a grid view window containing all the source workspace experiments. You can choose one or more experiments (holding down the CTRL key) and then, pressing the OK button, the experiments will be extracted in the corresponding experiment graphs to a file in JSON format.

* **AzureML-Scripts_ImportExperimentsFromJsonFiles.ps1**
After you modify the path of the folder where the json files of experiments are stored, and after you modify the full path of your destination workspace config file, the script will pop out a grid view window containing all the json file found in the specified folder. You can choose one or more json experiment files (holding down the CTRL key) and then, pressing the OK button, the experiments will be imported in the destination workspace.

A breaf tutorial is available at this blog post:

[How to bulk copy Azure ML Experiments from a Workspace to another one or do a Backup of them in Physical Files](http://blogs.solidq.com/en/businessanalytics/bulk-copy-azure-ml-experiments-workspace-another-backup-physical-files)
