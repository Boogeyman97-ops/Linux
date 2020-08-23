provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
  features {}
}

variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}
{
  "appId": "087ab2b7-78f7-42a1-aa68-625d9f2ab574",
  "displayName": "Terraform-sp-1",
  "name": "http://Terraform-sp-1",
  "password": "vo~Nfe-uQ.z4YGkFT6iYn-G5oE9~ko30se",
  "tenant": "426008e7-7e3f-4ad1-ba2d-7fd1e5c4d3b2"
}
