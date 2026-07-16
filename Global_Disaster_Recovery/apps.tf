# --- PRIMARY REGION (South Central US) ---

resource "azurerm_service_plan" "primary_plan" {
  name                = "primary-sp-us"
  resource_group_name = var.rg_name
  location            = var.primary_location
  os_type             = "Linux"
  sku_name            = "F1" # Ücretsiz SKU (Maliyet dostu)
}

resource "azurerm_linux_web_app" "primary_web" {
  name                = "ali-ecommerce-primary-us" # Global benzersiz olmalı
  resource_group_name = var.rg_name
  location            = var.primary_location
  service_plan_id     = azurerm_service_plan.primary_plan.id

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "REGION_NAME" = "PRIMARY-SOUTH-CENTRAL-US"
  }
}

# --- SECONDARY REGION (North Europe) ---

resource "azurerm_service_plan" "secondary_plan" {
  name                = "secondary-sp-eu"
  resource_group_name = var.rg_name
  location            = var.secondary_location
  os_type             = "Linux"
  sku_name            = "F1" # Ücretsiz SKU (Maliyet dostu)
}

resource "azurerm_linux_web_app" "secondary_web" {
  name                = "ali-ecommerce-secondary-eu" # Global benzersiz olmalı
  resource_group_name = var.rg_name
  location            = var.secondary_location
  service_plan_id     = azurerm_service_plan.secondary_plan.id

  site_config {
    always_on = false
    application_stack {
      dotnet_version = "6.0"
    }
  }

  app_settings = {
    "REGION_NAME" = "SECONDARY-NORTH-EUROPE"
  }
}