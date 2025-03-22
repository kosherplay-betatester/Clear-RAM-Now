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

2. **Right-click** PowerShell and choose **"Run as Administrator"**.

3. Navigate to the folder where the script is located:

   ```powershell
   cd "C:\Users\YourName\Downloads"
