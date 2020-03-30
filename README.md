# Management of Kubernetes Clusters using Azure DevOps and AKS Engine on Azure Stack Hub

Dependencies
- Github repository with your yaml pipelines and scripts, clone this repo as example
- Azure DevOps Linux Agent VM with access to target Azure Stack Hub stamps
- All scripts in the scripts directory need to have execute permissions
- Deploy a VM with access to the target Azure Stack Hub environment

## Install DevOps Pipeline Agent in a Linux VM
Follow intructions here: https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops

### Summary steps to install and configure the DevOps Agent
The following steps are not intended to substitute the instructions provided in the link above. If you are already familirized with Azure DevOps and have installed agents before, these instructions should serve as a quick refresher:

0. Create the Agent Pool in the Project Settings in Azure DevOps portal (example: stampregion-akse)
1. Get a Personal Access Token (PAT) from the Azure DevOps portal
2. Get the agent download URL from the Azure DevOps portal
3. Get the Azure Pipeline server URL from the Azure DevOps portal (https://dev.azure.com/<your org>/)
3. Connect to the VM, create "myagent" directory and install the Agent in the VM by downloading and expanding the tar file
4. Run sudo ./bin/installdependencies.sh to install any missing dependencies
5. Run ./config.sh and provide the server URL, PAT, Agent pool created above, default agent name, default work folder (_work)
6. Start the agent by running run.sh

### Steps to create a pipeline


