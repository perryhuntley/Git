module "nsg" {
  source              = "git::git@git.signintra.com:dct/azure/terraform-azurerm-nsg.git"
  location            = module.rg.location
  resource_group_name = module.rg.name
  security_group_name = "${var.topic}-${var.stage}-nsg-${var.application}-${module.map.region_map[var.location]}"

  custom_rules = [
    {
      name                                       = "AllowRDP"
      priority                                   = "121"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "3389"
      source_address_prefix                      = "10.236.247.0/27"
      
      destination_application_security_group_ids = [module.vm.asg]
    },
    
    {
      name                   = "BlockAny"
      priority               = "2000"
      direction              = "Inbound"
      access                 = "Deny"
      protocol               = "Tcp"
      source_port_ranges     = "*"
      destination_port_range = "*"
      description            = "BlockAny"
    },
  ]

  dynamic_rules = [
    {
      name                                       = "AllowSMB"
      priority                                   = "122"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "139,445"
      source_address_prefixes                    = ["10.220.0.0/16"]
      destination_application_security_group_ids = [module.vm.asg]
    },
    {
      name                                       = "AllowQLIK"
      priority                                   = "123"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "3552,443"
      source_address_prefixes                    = ["10.197.46.118/32", "10.197.44.94/32", "10.236.4.54/32", "10.227.8.0/22", "10.227.12.0/22", "10.227.16.0/22"]
      destination_application_security_group_ids = [module.vm.asg]
    },
    /*
    {
      name                                       = "AllowSQL"
      priority                                   = "126"
      direction                                  = "Inbound"
      access                                     = "Allow"
      protocol                                   = "Tcp"
      destination_port_range                     = "1433"
      source_address_prefixes                    = ["10.0.0.0/8"]
      destination_application_security_group_ids = [module.vm.asg]
    },
    */
  ]

  tags = local.tags
}
