# 🧠 Clear RAM Now – PowerShell Script

This PowerShell script automates the process of clearing unused memory (Empty Working Sets) using Microsoft's **RAMMap** utility. It checks for administrator privileges, ensures **RAMMap64.exe** is available, and creates a handy desktop shortcut named **"Clear RAM Now"** for one-click RAM cleanup.

---

## 🚀 Features

- ✅ Checks for **Administrator** rights before proceeding.
- 🔍 Verifies if **RAMMap64.exe** exists in the Windows directory.
- 🌐 Automatically downloads **Sysinternals Suite** if RAMMap is missing.
- 🖱️ Creates a **desktop shortcut** to run RAMMap with memory-clearing arguments.
- ⚡ Executes `RAMMap64.exe -Ew` to clear **Empty Working Sets**, freeing up RAM.

---

## 🛠️ Requirements

- **Windows OS**
- **Administrator privileges**
- Internet connection (only if RAMMap is not already installed)
- PowerShell 5.1+ or PowerShell 7

---

## 📥 Installation

1. Download the script:  
   Save `clearRamNow.ps1` to any folder on your PC (e.g., Downloads).
2. Navigate to the folder where the script is located:
3. **Right-click** PowerShell and choose **"Run as Administrator"**.
or "powershell.exe -ExecutionPolicy Bypass -File clearRamNow.ps1"

![image](https://github.com/user-attachments/assets/b0ae7e34-3cb3-4b79-824d-ca8e88499976)

![image](https://github.com/user-attachments/assets/40d28f62-cb77-4207-a0f8-8e5d017eb856)

## 📥 Happy Gaming
