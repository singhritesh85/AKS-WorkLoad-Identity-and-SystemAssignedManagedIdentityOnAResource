# AKS-workload-Identity-and-SystemAssignedManagedIdentityOnAResource
![image](https://github.com/user-attachments/assets/8bb43178-a6f3-48f7-b16e-6dedb40a297f)

Whenever an application running in Azure Resource tries to Access another Resource then you need Managed Identity, there are two types of Managed Identity one is System Assigned Identity and another is User Assigned Identity. 
In the first part of this project, I am explaining Azure VM gets the access of Azure Key Vault or the Azure Storage Account Container using System Assigned Identity. I had created the infrastructure using Terraform. After creation of the Infrastructure I logged into the Azure VM using SSH and tried to test whether I had the Access for Azure Key Vault or Storage Account Container as shown in the Screenshot attached below.
<br></br>
![image](https://github.com/user-attachments/assets/d21a49d7-3aa6-4f36-b986-c9ce8cddb195)

The above architecture diagram showed high level architecture diagram of the second part of the project. The kubernetes pod inside the AKS Cluster used Managed Identity to access Azure Storage Account container blob and Azure Key Vault Secrets. 
AKS Workload Identity enabled Kubernetes Pod to access Azure Resources without storing the credentials in the Cluster.











