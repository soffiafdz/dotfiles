# Unified Keybinding System Design

## Overview

Unified keybinding system across:
- **macOS**: Aerospace (WM) + Raycast (launcher/utilities) + Karabiner (key remapping)
- **Linux**: dwm (WM) + dmenu (launcher) + xkb (key remapping)
- **Keyboards**: Planck EZ, WriterDeck, 8BitDo, laptop keyboards

## Core Architecture

### WM Modifier Key

| Platform | Physical Key | Remapped to | WM Binding |
|----------|--------------|-------------|------------|
| macOS | Right Cmd | Hyper (Karabiner) | Aerospace → Hyper |
| Linux | Right Super | Super (native) | dwm → Mod4 |

**Principle**: Same physical key position (right side), same muscle memory across platforms.

### Keyboard Remapping

| Feature | macOS (Karabiner) | Linux (xkb) |
|---------|-------------------|-------------|
| Caps Lock | Esc (tap) / Ctrl (hold) | Escape |
| Right Cmd/Super | Hyper (Cmd+Ctrl+Alt+Shift) | Super (Mod4) |
| Right Alt | macOS compose | Compose key |
| Fn + HJKL | Arrow keys | N/A |

---

## Fundamental Paradigm Difference (Accepted)

**Focus navigation differs due to WM architecture:**
- **dwm**: Stack-based (master/stack), J/K navigates stack, H/L resizes
- **Aerospace**: Spatial (tree-based), HJKL navigates spatially

This is an **accepted difference**. Window navigation will feel different but layout/action keys match.

---

## Unified Keybindings

### Workspaces/Tags

| Action | Key | Status |
|--------|-----|--------|
| Switch to 1-9 | Hyper/Super + 1-9 | ✅ |
| Prev workspace | Hyper/Super + G | ✅ |
| Next workspace | Hyper/Super + ; | ✅ |
| Last workspace | Hyper/Super + Tab | ✅ |
| View all | Hyper/Super + 0 | ✅ (different: dwm=view all, Aero=native fullscreen) |

### Window Actions

| Action | Key | Status |
|--------|-----|--------|
| Close window | Hyper/Super + Q | ✅ |
| Force kill | Super + Shift + Q | dwm only |
| Fullscreen | Hyper/Super + F | ✅ |
| Float toggle | Hyper/Super + O | ✅ |
| Zoom/Layout cycle | Hyper/Super + Space | ✅ (dwm=zoom, Aero=cycle) |
| Resize - | Hyper + - / Super + H | Different keys (acceptable) |
| Resize + | Hyper + = / Super + L | Different keys (acceptable) |

### Layouts

| Action | Aerospace | dwm |
|--------|-----------|-----|
| Tiles/Tile | Hyper + T | Super + T |
| Accordion/Monocle | Hyper + Y | Super + Y |
| Bstack | — | Super + Shift + T |
| Deck | — | Super + Shift + Y |
| CenteredMaster | — | Super + U |
| CFloatingMaster | — | Super + Shift + U |
| nmaster +/- | — | Super + I / Shift + I |

**Note**: dwm has more layout options due to its design. T and Y are consistent across both.

### Application Launchers

| Action | Key | Status |
|--------|-----|--------|
| Terminal | Hyper/Super + Return | ✅ |
| Terminal + tmux | Super + Shift + Return | dwm only |
| Browser | Hyper/Super + W | ✅ |
| Editor (nvim) | Hyper/Super + E | ✅ |
| Vimwiki | Super + Shift + E | dwm only |
| File manager (yazi) | Hyper/Super + R | ✅ |
| System monitor | Super + Shift + R | dwm only |
| Launcher | Hyper/Super + D | ✅ (Raycast / dmenu) |
| Password manager | Super + Shift + D | dwm (dmenupass) |

### Monitors

| Action | Key | Status |
|--------|-----|--------|
| Focus next monitor | Hyper/Super + N | ✅ |
| Focus prev monitor | Hyper/Super + P | ✅ |
| Send to next monitor | Move mode + N | ✅ |
| Send to prev monitor | Move mode + P | ✅ |

**Note**: Monitor sending uses move mode only (no direct Shift+N/P).

### Move Mode (Keychord)

**Access**: Hyper/Super + M, then:

| Second Key | Action | Platform |
|------------|--------|----------|
| 1-9 | Send window to workspace | Both |
| G | Send to prev workspace | Both (Aero follows) |
| ; | Send to next workspace | Both (Aero follows) |
| N | Send to next monitor | Both |
| P | Send to prev monitor | Both |
| H/J/K/L | Move window spatially | Aerospace only |
| M | Mount drive (dmenumount) | dwm only |
| U | Unmount drive (dmenuumount) | dwm only |
| Esc | Cancel move mode | Both |

**Implementation**: dwm uses keychord patch, Aerospace has native mode support.

### Toggleview Mode (dwm only)

**Access**: Super + C, then 1-9 to toggle viewing that tag.

---

## Platform-Specific Bindings

### dwm-Only

| Action | Key | Notes |
|--------|-----|-------|
| Focus stack down | J | Stack navigation |
| Focus stack up | K | Stack navigation |
| Push down in stack | Shift + J | — |
| Push up in stack | Shift + K | — |
| Focus master | V | — |
| Screenshot | S | flameshot gui |
| Full screenshot | Shift + S | flameshot full |
| Clipboard history | X | clipmenu |
| Toggle gaps | Z | vanitygaps |
| Reset gaps | Shift + Z | — |
| Toggle bar | Shift + B | — |
| Toggle alt tags | B | — |
| System menu | Backspace | sysaction |
| Refresh bar | Shift + ' | refbar |
| Audio mixer | Shift + A | pulsemixer |
| Volume down | - | pamixer |
| Volume up | Shift + - | pamixer |
| Mute toggle | = | pamixer |
| Cfact + | Shift + H | — |
| Cfact - | Shift + L | — |
| Cfact reset | ' | — |

### Aerospace-Only

| Action | Key | Notes |
|--------|-----|-------|
| Focus left/down/up/right | H/J/K/L | Spatial navigation |
| Balance window sizes | B | — |
| Reload config | / | — |

### Raycast (macOS)

Configure in Raycast Settings → Extensions:

| Hotkey | Command | dwm Equivalent |
|--------|---------|----------------|
| Hyper + S | Screenshot (area) | Super + S |
| Hyper + Shift + S | Screenshot (full) | Super + Shift + S |
| Hyper + X | Clipboard History | Super + X |
| Hyper + Backspace | System Commands | Super + Backspace |
| Hyper + Shift + D | 1Password/Passwords | Super + Shift + D |

---

## Free Keys

### dwm

Plain: A, ,, .
Shifted: Shift+O, Shift+F, Shift+G, Shift+;, Shift+N, Shift+P, Shift+Space, Shift+X

### Aerospace

A (dwm uses for audio), S (Raycast for screenshot), X (Raycast for clipboard)

---

## Design Principles

1. **Muscle memory first**: Same physical key = same action where possible
2. **Accept paradigm differences**: dwm (stack) vs Aerospace (spatial) have different navigation
3. **Unified where it matters**: Workspaces, launchers, window actions, monitors
4. **Platform-specific where needed**: Layouts, system utilities, clipboard
5. **Move mode for complex actions**: Multi-step operations (send to workspace/monitor)
6. **Freed keys for future use**: Dropped rarely-used features to simplify

---

## Implementation Status

✅ **Completed:**
- Karabiner: Right Cmd → Hyper
- Aerospace: All keybindings updated
- dwm: Keychord patch applied, all keybindings updated
- Move mode: Unified across both systems
- Monitor navigation: N/P on both, move mode for sending
- Layout keys: T and Y consistent
- Float toggle: O on both
- Cheatsheet: Comprehensive reference created
- Planck layout: Redesigned for WriterDeck compatibility

📋 **Documented for later:**
- Raycast hotkeys setup
- Linux-specific tasks (clipmenu, dwm compilation)
- Application configuration (Sioyek, Atuin, Restic)
- Browserpass extension installation

---

## Reference Files

- Full cheatsheet: `docs/keybindings.txt`
- Raycast setup: `docs/raycast-hotkeys.md`
- Planck layout: `docs/planck-layout-design.md`
- Deferred tasks: `docs/linux-setup-tasks.md`
- Software decisions: `docs/software-setup.md`
