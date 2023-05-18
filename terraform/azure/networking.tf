resource "azurerm_virtual_network" "example" {
  name                = "casdemo-vn-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "49bac9b1-1766-497c-95d5-39e797d0a4a0"
  }
}

resource "azurerm_subnet" "example" {
  name                 = "casdemo-${var.environment}"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_interface" "ni_linux" {
  name                = "casdemo-linux-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "5e8cbe84-c0e1-4249-9b81-942b4d3b1699"
  }
}

resource "azurerm_network_interface" "ni_win" {
  name                = "casdemo-win-${var.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    yor_trace = "79b9973e-179b-4641-9ec1-ab792d9e4c06"
  }
}

resource azurerm_network_security_group "bad_sg" {
  location            = var.location
  name                = "casdemo-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 200
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "22-22"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 300
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "3389-3389"
    destination_address_prefix = "*"
  }
  tags = {
    yor_trace = "644b684b-3828-4ecf-8f6b-684f22956d91"
  }
}

resource azurerm_network_watcher "network_watcher" {
  location            = var.location
  name                = "casdemo-network-watcher-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  tags = {
    yor_trace = "6e513a62-4193-4ffc-92e2-241dd185966b"
  }
}

resource azurerm_network_watcher_flow_log "flow_log" {
  enabled                   = false
  network_security_group_id = azurerm_network_security_group.bad_sg.id
  network_watcher_name      = azurerm_network_watcher.network_watcher.name
  resource_group_name       = azurerm_resource_group.example.name
  storage_account_id        = azurerm_storage_account.example.id
  retention_policy {
    enabled = false
    days    = 10
  }
  tags = {
    yor_trace = "a98357ab-1db2-4763-8873-62c87677876e"
  }
}