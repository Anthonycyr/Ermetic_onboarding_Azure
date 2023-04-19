# README #

This terraform script do:
- create an enterprise app in Azure AD
- asigned two roles (Reader and Key Vault Reader) to each subscription available

https://ca.app.ermetic.com/customer/docs/integrateYourIdentityProvider/addAnAzureActiveDirectoryTenant/index
https://ca.app.ermetic.com/customer/docs/connectYourCloudAccounts/onboardAnAzureSubscription/index

Requirements:

Access to a Azure AD tenants with Global Admin or Cloud Application Administrator roles

Owner role on the Subscription

Step 

Add the new Azure AD tenant in Settings/identity providers

Accept the Admin consent to allow Ermetic App



3.  Go to Accounts/Azure to add a subscription

  Step 1: Choose the correct tenant

  Step 2: add the correct Subscription ID

6. Run the Terraform script to create the Ermetic enterprise app in Azure AD and assigned rôle Reader and KeyVault Reader to the app for each available subscription. 

git clone codecommit::ca-central-1://codecommit_ermetic

7. You can go in the Ermetic console and Click on Finish

Ermetic is on board !

If you ever need to remove Ermetic from a client you can run the Terraform script with:

terraform plan -destroy
terraform apply -destroy
