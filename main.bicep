// AMPT-prod Secure Landing Zone - Infrastructure as Code

targetScope = 'subscription' // This allows us to create the Resource Group

param rgName string = 'AMPT-prod'
param location string = 'centralindia'
param prefix string = 'AMPT2026-Bicep'

// 1. Create Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    Environment: 'Production'
    Department: 'Cloud-Ops'
    Service: 'Network-Foundation'
    Project: '${prefix}-Project'
    DeployedBy: 'Arnav-Mohan'
  }
} 


// 2. Deploy the Network using a Module
module networkResources './network.bicep' = {
  name: 'networkDeployment'
  scope: resourceGroup(rg.name) // Tells the module to deploy INSIDE the new Resource Group
  params: {
    location: location
  }
}
