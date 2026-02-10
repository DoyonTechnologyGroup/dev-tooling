# Azure Container Apps — Setup Guide for New Apps

Reusable steps to deploy a new app to Azure Container Apps with GitHub Actions. Use this when standing up a new repo.

---

## Overview

| Who | Responsibility |
|-----|----------------|
| **You (dev/requester)** | Create Azure resources (resource group, environment, container app), configure the repo workflow, and collect values for GitHub Secrets. |
| **IT** | App registration (or federated credential for OIDC), role assignments (Contributor, ACR push), and sending back Client ID, Tenant ID, subscription ID, ACR credentials. |

---

## 1. What You Do First (Before Contacting IT)

### 1.1 Repo readiness

- [ ] App has a **Dockerfile** that runs the service (e.g. `EXPOSE 8000`, `CMD ["uvicorn", ...]`).
- [ ] Repo has (or you will add) a GitHub Actions workflow that builds the image, pushes to ACR, and deploys with `azure/container-apps-deploy-action@v2`.

### 1.2 Naming (decide and write down)

Pick names you’ll use everywhere (replace `my-app` with your app name):

| Item | Example | Your value |
|------|---------|------------|
| Resource group | `rg-my-app` | |
| Container App environment | `env-my-app` | |
| Container App name | `ca-my-app-production` | |
| GitHub environment (optional) | `production` | |

### 1.3 Create Azure resources (if you have access)

If you have Contributor on a subscription:

```bash
# Replace my-app, eastus2, and placeholder secrets with your values
APP_NAME=my-app
RG=${APP_NAME}
ENV_NAME=env-${APP_NAME}
CA_NAME=ca-${APP_NAME}-production
LOCATION=eastus2

az group create --name $RG --location $LOCATION

az containerapp env create \
  --name $ENV_NAME \
  --resource-group $RG \
  --location $LOCATION

az containerapp create \
  --name $CA_NAME \
  --resource-group $RG \
  --environment $ENV_NAME \
  --image mcr.microsoft.com/azuredocs/containerapps-helloworld:latest \
  --target-port 8000 \
  --ingress external \
  --min-replicas 1 \
  --max-replicas 3 \
  --cpu 1.0 \
  --memory 2Gi \
  --secrets my-secret=placeholder-update-later \
  --env-vars MY_VAR=secretref:my-secret \
  --output table
```

If you don’t have access, skip this and ask IT to create the resource group and container app (see IT template).

### 1.4 Get the Container App URL

```bash
az containerapp show \
  --name $CA_NAME \
  --resource-group $RG \
  --query "properties.configuration.ingress.fqdn" -o tsv
```

URL = `https://<that-fqdn>`. Save it for GitHub Secret `CONTAINER_APP_URL`.

### 1.5 List what you need from IT

Collect:

- **App registration (or OIDC):** Client ID, Tenant ID, and either a client secret or a federated credential for GitHub Actions.
- **Subscription:** Subscription ID where the Container App (and ACR) live.
- **ACR:** Registry URL, username, password (if using a shared ACR).
- **Role:** Contributor on the resource group (and AcrPush on ACR if it’s in another resource group).

Use the **IT request template** below and fill in the bracketed sections, then send to IT.

---

## 2. What You Add in GitHub

After IT responds, add these in the repo:

- **Settings → Secrets and variables → Actions** (and Environment secrets if you use an environment like `production`):

| Secret | Description |
|--------|-------------|
| `AZURE_CLIENT_ID` | From IT (app registration) |
| `AZURE_TENANT_ID` | From IT |
| `AZURE_SUBSCRIPTION_ID` | From IT |
| `AZURE_CLIENT_SECRET` | From IT (only if using client secret; omit if using OIDC) |
| `REGISTRY_URL` | ACR login server |
| `REGISTRY_USERNAME` | ACR username |
| `REGISTRY_PASSWORD` | ACR password |
| `RESOURCE_GROUP` | e.g. `rg-my-app` |
| `CONTAINER_APP_NAME_PRODUCTION` | e.g. `ca-my-app-production` |
| `CONTAINER_APP_URL` | `https://<fqdn>` from step 1.4 |

- **Workflow:** Use `azure/login@v2` (with `creds` or OIDC) then `azure/container-apps-deploy-action@v2` with the same secret names. For env vars with spaces or special characters in the deploy action, quote the whole `KEY=value` (e.g. `"AVAILABLE_MODELS=id:Label,id:Label"`).

---

## 3. After IT Configures Access

- If you use **OIDC:** Workflow uses `client-id`, `tenant-id`, `subscription-id`, `audience: api://AzureADTokenExchange`; no `AZURE_CLIENT_SECRET`.
- If you use **client secret:** Workflow uses `creds` with the secret.
- Run the deploy workflow. If you see **“No subscriptions found”**, the service principal needs **Contributor** (or equivalent) on the subscription or resource group—ask IT to add the role assignment. If you see **“AADSTS70025: no configured federated identity credentials”**, the app needs a federated credential for GitHub Actions (Entity type: Environment, audience: `api://AzureADTokenExchange`); use client-secret login until IT adds it.

---

## 4. IT Request Template

Use the template in **[templates/it-request-azure-container-app.md](templates/it-request-azure-container-app.md)**. Copy it, fill in the bracketed parts, and send to IT (email or ticket).
