# Raycast Hotkeys Setup

Hotkeys to configure in Raycast to match dwm keybindings.

## Setup Instructions

1. Open Raycast Settings (`Cmd + ,`)
2. Go to **Extensions**
3. Search for each extension below
4. Click the hotkey field and press **Right Cmd + key**
   (Karabiner translates Right Cmd to Hyper = Cmd+Ctrl+Alt+Shift)

## Hotkeys to Configure

| Hotkey | Extension | Command | dwm Equivalent | Status |
|--------|-----------|---------|----------------|--------|
| `Hyper + S` | Screenshot | Capture Area | `Super + S` (flameshot gui) | ✅ Configured |
| `Cmd + Shift + 3` | (macOS built-in) | Capture Fullscreen | `Super + Shift + S` | Stock macOS, nothing to set |
| `Hyper + X` | Clipboard History | Clipboard History | `Super + X` (clipmenu) | ✅ Configured |
| `Hyper + Backspace` | System | System Commands | `Super + Backspace` (sysaction) | ❌ Cannot use (conflict) |
| `Hyper + Shift + D` | 1Password | Search Passwords | `Super + Shift + D` (dmenupass) | ❌ Impossible, see below |

## Extensions to Install (if not present)

- **Screenshot** - Built-in
- **Clipboard History** - Built-in
- **System Commands** - Built-in (search "Shutdown", "Restart", "Sleep")
- **1Password** - Install from Raycast Store (or use macOS Passwords app)

## Notes

- **Hyper already includes Shift** (Karabiner maps Right Command to
  Cmd+Ctrl+Alt+Shift), so `Hyper + Shift + <key>` is the same chord as
  `Hyper + <key>` and cannot be bound separately. `Hyper + Shift + D` is just
  `Hyper + D`, which Aerospace already uses to open Raycast.
- **These hotkeys are per-machine.** Raycast keeps them in an encrypted local
  database that nothing in this repo can stow, so each Mac has to be configured
  by hand from this table. The statuses below refer to noctua.
- Hyper key = Right Command via Karabiner
- These match the corresponding dwm keybindings for muscle memory
- D (Raycast launcher) is already set as `Hyper + D` in Aerospace config
