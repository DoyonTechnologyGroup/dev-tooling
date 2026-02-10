# IT Request: Azure Container App + GitHub Actions Deploy

**Copy this template, fill in the bracketed sections, and send to IT (email or ticket).**

---

## Subject

Request: App registration and Azure access for GitHub Actions deploy — [APP_NAME]

---

## What we're asking for

We need the following so our GitHub Actions workflow can **build a Docker image, push it to our Azure Container Registry, and deploy to an Azure Container App** on every push to `main`:

1. **App registration** (or use of an existing service principal) with:
   - **Contributor** on the resource group: **[RESOURCE_GROUP]**  
     (So the workflow can update the Container App and push images if ACR is in the same RG.)
   - **AcrPush** on the Container Registry **[ACR_NAME]** (or Contributor on its resource group)  
     *Only if the ACR is in a different resource group.*

2. **Values to send back to us** (we will store these as GitHub Actions secrets; they are not committed to the repo):

   | What we need | Where to get it | We'll store as |
   |--------------|-----------------|-----------------|
   | Client ID | App registration → Overview | `AZURE_CLIENT_ID` |
   | Tenant ID | App registration → Overview | `AZURE_TENANT_ID` |
   | Subscription ID | Subscription where the Container App and ACR live | `AZURE_SUBSCRIPTION_ID` |
   | Client secret **value** | App registration → Certificates & secrets (create if needed) | `AZURE_CLIENT_SECRET` |
   | ACR login server | Container Registry → Overview | `REGISTRY_URL` |
   | ACR username | Container Registry → Access keys | `REGISTRY_USERNAME` |
   | ACR password | Container Registry → Access keys | `REGISTRY_PASSWORD` |

3. **Optional but preferred — OIDC (federated credential):**  
   If you can add a **federated identity credential** for GitHub Actions instead of a client secret, we can use that and avoid storing a long-lived secret. Details:
   - **Entity type:** Environment
   - **GitHub org/repo:** [GITHUB_ORG]/[REPO_NAME]
   - **Environment name:** [e.g. production]
   - **Audience:** `api://AzureADTokenExchange`  
   If you do this, we will **not** need the client secret value; we only need Client ID, Tenant ID, and Subscription ID. You still need to assign **Contributor** (and AcrPush if ACR is in another RG) to this app.

---

## What we've already done (no action needed from IT)

- [ ] Created resource group: **[RESOURCE_GROUP]**
- [ ] Created Container App environment: **[ENV_NAME]**
- [ ] Created Container App: **[CONTAINER_APP_NAME]**
- [ ] We have (or will add) the workflow in the repo; we only need the credentials and role assignments above.

*Delete any bullets above that don’t apply and add any that do.*

---

## Summary for IT

| Item | Value |
|------|--------|
| **Resource group** | [RESOURCE_GROUP] |
| **Container App name** | [CONTAINER_APP_NAME] |
| **Subscription** (for role assignment) | [SUBSCRIPTION_ID if known, or "default subscription for [TEAM/PROJECT]"] |
| **ACR** (name / resource group) | [ACR_NAME] / [ACR_RESOURCE_GROUP] |
| **Preferred auth** | OIDC (federated credential) **or** client secret |

---

## Notes for IT (permissions)

- **No redirect URIs** and **no API permissions** (e.g. Microsoft Graph) are required. This is machine-to-machine only (GitHub Actions → Azure).
- Access is controlled by **Azure role assignments** only: Contributor on the Container App's resource group, and AcrPush (or Contributor on ACR's RG) if the registry is elsewhere.

---

*Template version: 1.0 — for use with Azure Container Apps + GitHub Actions.*
