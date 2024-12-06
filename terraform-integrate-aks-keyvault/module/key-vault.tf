data "azurerm_client_config" "dexter" {}

resource "azurerm_key_vault" "keyvault" {
  name                        = "dexterkeyvault"
  location                    = azurerm_resource_group.aks_rg.location
  resource_group_name         = azurerm_resource_group.aks_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.dexter.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
#  enabled_for_deployment      = true
#  enabled_for_template_deployment = true  

  public_network_access_enabled = true

  sku_name = "standard"

  tags = {
    environment = var.env 
  }

}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "secret_officer" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "keyvault_secret1" {
  name         = "username"
  value        = "dexter"
  key_vault_id = azurerm_key_vault.keyvault.id
  
  depends_on = [azurerm_role_assignment.secret_officer]
}

resource "azurerm_key_vault_secret" "keyvault_secret2" {
  name         = "password"
  value        = "Admin123"
  key_vault_id = azurerm_key_vault.keyvault.id

  depends_on = [azurerm_role_assignment.secret_officer]
}

resource "azurerm_role_assignment" "keyvault_role_assignment_vm" {
  scope                = azurerm_resource_group.aks_rg.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_linux_virtual_machine.azure_vm_azurevm.identity[0].principal_id
}

resource "azurerm_role_assignment" "secret_user1" {
  scope                = "${azurerm_key_vault.keyvault.id}/secrets/${azurerm_key_vault_secret.keyvault_secret1.name}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "secret_user2" {
  scope                = "${azurerm_key_vault.keyvault.id}/secrets/${azurerm_key_vault_secret.keyvault_secret2.name}"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "role_assignment_mi" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.keyvault.id
}

resource "azurerm_role_assignment" "role_assignment_storageaccount" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.azure_sa.id
}

resource "azurerm_role_assignment" "container_access" {
  scope                = azurerm_storage_container.azure_sa_container.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
