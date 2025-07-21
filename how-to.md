Oto **kompletny, aktualny przewodnik** krok po kroku do pracy z plikami Bicep w PowerShell:

---

## **1. Przygotowanie środowiska**

✅ Zainstaluj [Azure CLI](https://docs.microsoft.com/pl-pl/cli/azure/install-azure-cli)
✅ Zainstaluj [Bicep CLI](https://learn.microsoft.com/pl-pl/azure/azure-resource-manager/bicep/install) (lub zaktualizuj, jeśli masz starszą wersję):

```powershell
az bicep install
# lub aktualizacja
az bicep upgrade
```

✅ Zaloguj się do swojej subskrypcji Azure:

```powershell
az login
az account set --subscription "SUBSCRIPTION_ID"
```

---

## **2. Budowanie (kompilacja) pliku Bicep**

Choć Azure CLI pozwala wdrażać pliki .bicep bezpośrednio, możesz najpierw **zbudować do ARM JSON** w celach testowych lub do kontroli:

```powershell
az bicep build --file ./main.bicep
```

✔️ Wynik: Powstanie plik `main.json` w tym samym katalogu.
✔️ Możesz przejrzeć strukturę i upewnić się, że wszystko generuje się poprawnie.

---

## **3. Walidacja (testowanie szablonu przed wdrożeniem)**

**Validate** sprawdza poprawność pliku oraz dostępność zasobów, ale NIC nie tworzy:

```powershell
az deployment sub validate \
  --location westeurope \
  --template-file ./main.bicep \
  --parameters adminUsername=myAdmin adminPassword='MyPa$$w0rd!'
```

✅ Użyj:

* `az deployment sub validate` jeśli wdrażasz zasoby na poziomie **subskrypcji** (np. Resource Group).
* `az deployment group validate` jeśli wdrażasz zasoby do **resource group**.

Np. dla resource group:

```powershell
az deployment group validate \
  --resource-group myResourceGroup \
  --template-file ./main.bicep \
  --parameters adminUsername=myAdmin adminPassword='MyPa$$w0rd!'
```

---

## **4. Wdrożenie szablonu (Deployment)**

### **a) Na poziomie Resource Group**

Jeżeli Twój Bicep tworzy zasoby w resource group (np. maszyny, VNETy, storage):

```powershell
az deployment group create \
  --resource-group myResourceGroup \
  --template-file ./main.bicep \
  --parameters adminUsername=myAdmin adminPassword='MyPa$$w0rd!'
```

---

### **b) Na poziomie Subskrypcji (np. tworzenie resource group)**

```powershell
az deployment sub create \
  --location westeurope \
  --template-file ./main.bicep \
  --parameters param1=value1 param2=value2
```

---

### **c) Z parametrami w osobnym pliku**

Jeśli masz plik `parameters.json`:

```powershell
az deployment group create \
  --resource-group myResourceGroup \
  --template-file ./main.bicep \
  --parameters @parameters.json
```

---

## **5. Sprawdzenie statusu wdrożenia**

Podczas wdrożenia CLI pokazuje w konsoli przebieg.
Po wdrożeniu możesz sprawdzić zasoby w **Azure Portal** lub poleceniem:

```powershell
az resource list --resource-group myResourceGroup
```

---

## **6. Aktualizacja Bicep**

Każde kolejne uruchomienie deploymentu wprowadza **zmiany zgodnie z plikiem Bicep** (ARM jest idempotentny).

---

### **7. Przydatne polecenia dodatkowe**

✔️ **Sprawdzenie wersji Bicep**

```powershell
az bicep version
```

✔️ **Formatowanie kodu Bicep (VSCode)**
Zainstaluj [Bicep Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) i używaj `Shift + Alt + F` do formatowania.

✔️ **Analiza lintera**

W VSCode pojawią się ostrzeżenia np. o nieużywanych parametrach, preferencjach interpolacji itp.

---

## **8. Podsumowanie – workflow PowerShell**

1. `az login` i `az account set`
2. `az bicep build --file ./main.bicep` (opcjonalnie)
3. `az deployment group validate` – sprawdź błędy bez zmian w chmurze
4. `az deployment group create` – pełne wdrożenie

---

Jeśli chcesz, mogę przygotować Ci również:

* **Template pliku parameters.json** dla Twojego projektu
* **Gotowy skrypt PowerShell .ps1** do wykonywania wszystkich kroków (build, validate, deploy) w jednej sesji,
* **Porównanie tych kroków z uruchamianiem Bicep w GitHub Actions** dla pełnej automatyzacji Twoich labów i projektów.

Daj znać, a rozwinę ten temat pod Twoje bieżące wdrożenia AD, AVD i VM w chmurze.




az deployment group what-if \
  --resource-group <your-rg> \
  --template-file main.bicep \
  --parameters adminUsername='test' adminPassword='YourPassword123!'
az deployment group create --resource-group myTestRG --template-
file main.bicep --parameters adminUsername='myuser' adminPassword='MyP@ssw0rd123!'