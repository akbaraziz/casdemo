resource "azurerm_storage_account" "test_blob" {
  name                          = var.st.name
  resource_group_name           = var.rg_shared_name
  location                      = var.rg_shared_location
  account_tier                  = var.st.tier
  account_replication_type      = var.st.replication
  public_network_access_enabled = true
  tags = {
    yor_trace = "760e5184-f044-4e7a-ac28-1c209ee570d8"
  }
}