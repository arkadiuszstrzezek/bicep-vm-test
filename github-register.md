Poniżej znajdziesz **kompletny przewodnik krok po kroku** jak wdrożyć Twój szablon Bicep (tworzący VM z Windows Server i instalujący kontroler domeny) za pomocą **GitHub Actions**, wraz z pełnym wyjaśnieniem i przykładowym plikiem YAML.

---

# ✅ **1. Załóż założenia do tego flow**

🔹 Masz repozytorium GitHub z plikiem `.bicep`, np. `main.bicep`
🔹 Masz subskrypcję Azure i utworzony Service Principal do logowania GitHub Actions
🔹 Masz grupę zasobów, w której chcesz wdrożyć tę maszynę

---

## 🔑 **2. Utwórz Service Principal w Azure**

W PowerShell / Azure CLI:

```bash
az ad sp create-for-rbac --name "github-bicep-deployer" --role contributor --scopes /subscriptions/<subscriptionId> --sdk-auth
```

Skopiuj **output JSON**. Będzie wyglądał np.:

```json
{
  "clientId": "...",
  "clientSecret": "...",
  "subscriptionId": "...",
  "tenantId": "...",
  ...
}
```

---

### 🔒 **3. Dodaj sekret do GitHub Actions**

1. Przejdź do repozytorium w GitHub
2. Wejdź w **Settings → Secrets and variables → Actions**
3. Kliknij **“New secret”**
4. Nazwij go **AZURE\_CREDENTIALS** i wklej **cały JSON z outputu powyżej**

---

# ⚙️ **4. Przygotuj plik YAML workflow**

Utwórz plik `.github/workflows/deploy-bicep.yml` w repozytorium:

```yaml
name: Deploy Bicep AD DS

on:
  push:
    branches:
      - main  # lub inna gałąź, z której chcesz deployować
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Login to Azure
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Deploy Bicep template (WhatIf)
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ fromJson(secrets.AZURE_CREDENTIALS).subscriptionId }}
          resourceGroupName: <YOUR-RESOURCE-GROUP-NAME>
          template: ./main.bicep
          parameters: |
            domainName=<your.domain.name>
            adminUsername=<localadminusername>
            adminPassword=<YourPasswordHere>
            safeModePassword=<YourSafeModePasswordHere>
          deploymentMode: Validate

      - name: Deploy Bicep template (Final)
        uses: azure/arm-deploy@v1
        with:
          subscriptionId: ${{ fromJson(secrets.AZURE_CREDENTIALS).subscriptionId }}
          resourceGroupName: <YOUR-RESOURCE-GROUP-NAME>
          template: ./main.bicep
          parameters: |
            domainName=<your.domain.name>
            adminUsername=<localadminusername>
            adminPassword=<YourPasswordHere>
            safeModePassword=<YourSafeModePasswordHere>
          deploymentMode: Incremental
```

---

## 💡 **Wyjaśnienie krok po kroku**

| 🔢 | **Krok**            | **Opis**                                                                                |
| -- | ------------------- | --------------------------------------------------------------------------------------- |
| 1  | **on: push**        | Workflow uruchamia się przy pushu do `main` oraz manualnie przez **workflow\_dispatch** |
| 2  | **checkout**        | Pobiera Twój kod z repozytorium                                                         |
| 3  | **azure/login\@v1** | Loguje do subskrypcji Azure przy użyciu sekretu                                         |
| 4  | **Deploy (WhatIf)** | Wykonuje **walidację i What-If** (deploymentMode: Validate)                             |
| 5  | **Deploy (Final)**  | Wdraża w trybie **Incremental** czyli finalne utworzenie zasobów                        |

---

### ✅ **5. Zmień parametry**

W powyższym YAML podmień:

* `<YOUR-RESOURCE-GROUP-NAME>` na nazwę grupy zasobów w Azure
* `<your.domain.name>` na np. `contoso.com`
* `<localadminusername>` i `<YourPasswordHere>` na dane logowania do VM
* `<YourSafeModePasswordHere>` na hasło dla Directory Services Restore Mode

---

## 🔒 **6. Zabezpiecz hasła w GitHub Secrets**

Zamiast wpisywać je w YAML wprost:

1. Utwórz kolejne sekrety, np.:

   * **DOMAIN\_NAME**
   * **ADMIN\_USERNAME**
   * **ADMIN\_PASSWORD**
   * **SAFEMODE\_PASSWORD**

2. W YAML zastąp je odwołaniami:

```yaml
parameters: |
  domainName=${{ secrets.DOMAIN_NAME }}
  adminUsername=${{ secrets.ADMIN_USERNAME }}
  adminPassword=${{ secrets.ADMIN_PASSWORD }}
  safeModePassword=${{ secrets.SAFEMODE_PASSWORD }}
```

---

# 🚀 **7. Deployment krok po kroku (final flow)**

✅ **Commit** pliku `deploy-bicep.yml` do `.github/workflows`
✅ **Push** do gałęzi `main`
✅ **Wejdź w GitHub Actions** w repozytorium – zobaczysz running workflow
✅ **Sprawdź logi w krokach `WhatIf` i `Final`**
✅ Po kilku minutach masz VM z Windows Server 2019 promowaną do roli **kontrolera domeny Active Directory**

---

## 📝 **Dodatkowe rekomendacje**

🔹 Skonfiguruj **Branch Protection Rules** aby deployment nie odpalał się z nieautoryzowanych commitów
🔹 Rozważ dodanie **Azure Key Vault** i GitHub OIDC dla zwiększenia bezpieczeństwa
🔹 Jeśli chcesz, przygotuję dla Ciebie **pełne rozwiązanie GitHub Actions z OIDC, Terraform, Bicep i DSC** na potrzeby Twojego standardu projektowego

---

### 💬 **Daj znać, jeśli chcesz:**

* **Pipeline do DSC** (Desired State Configuration)
* **Deployment z auto-join do istniejącej domeny**
* **Przykład rollback i destroy w GitHub Actions**

Pomogę Ci ustandaryzować infrastrukturę jako kod zgodnie z Twoimi obecnymi projektami w Azure DevOps, GitHub Actions i Bicep.
