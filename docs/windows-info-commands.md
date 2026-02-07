# Windows System Information Commands

Quick reference for checking system details before formatting.

## Get Windows License Key

Open PowerShell or Command Prompt (as Administrator):

```powershell
wmic path softwarelicensingservice get OA3xOriginalProductKey
```

This shows the OEM license key embedded in your motherboard BIOS/UEFI.

Alternative method (shows current installed key):

```powershell
slmgr /dli
```

Or to see the full license info:

```powershell
slmgr /dlv
```

**Save this key** — you'll need it when reinstalling Windows.

## Check CPU Type (Intel vs AMD)

```cmd
wmic cpu get name
```

Or via PowerShell:

```powershell
Get-WmiObject -Class Win32_Processor | Select-Object Name
```

Output will show something like:
- **Intel:** "Intel(R) Core(TM) i7-10700K CPU @ 3.80GHz"
- **AMD:** "AMD Ryzen 7 5800X 8-Core Processor"

## Other Useful Info Before Formatting

### RAM amount and speed:
```powershell
wmic memorychip get capacity, speed
```

### Storage drives:
```powershell
wmic diskdrive get model, size
```

### Windows version:
```powershell
winver
```

### Full system summary:
```powershell
systeminfo
```

## AtlasOS Requirements

- **Windows edition:** Pro, Pro for Workstations, or Enterprise (Home NOT supported)
- **CPU:** Any modern x86-64 (both Intel and AMD work)
- **RAM:** 4 GB minimum, 8+ recommended
- **Storage:** 64 GB minimum for Windows partition

Check your edition:

```powershell
wmic os get caption
```

If you have Home edition, you'll need to either:
- Upgrade to Pro (costs money)
- Install Windows Pro instead (requires Pro license)
