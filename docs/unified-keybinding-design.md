# Unified Keybinding System Design

## Overview

This document captures the design decisions for a unified keybinding system across:
- **macOS**: Aerospace (WM) + Raycast (launcher/utilities) + Karabiner (key remapping)
- **Linux**: dwm (WM) + dmenu (launcher) + xkb (key remapping)
- **Keyboards**: Planck EZ, 8BitDo Retro Keyboard, laptop keyboards

## Core Architecture

### WM Modifier Key

| Platform | Physical Key | What it sends | What WM sees |
|----------|--------------|---------------|--------------|
| macOS | Right Cmd | Hyper (via Karabiner) | Aerospace binds to Hyper |
| Linux | Right Super | Super (native) | dwm binds to Mod4 |
| macOS (8BitDo) | Macro button | Hyper combo | Aerospace |
| Linux (8BitDo) | Left Win | Super | dwm |

### Keyboard Remapping

| Feature | macOS (Karabiner) | Linux (xkb) |
|---------|-------------------|-------------|
| Caps Lock | Esc (tap) / Ctrl (hold) | Escape only |
| Right Alt | macOS compose | Compose key |
| Fn + HJKL | Arrow keys | N/A |

## Fundamental Difference: Accepted

- **dwm**: Stack-based (master/stack), J/K moves through stack, H/L resizes
- **Aerospace**: Spatial (i3-style), HJKL moves directionally

This difference is accepted. Window navigation will feel different between OSes.

---

## Unified Keybindings (What Should Match)

### Workspaces/Tags

| Action | Key | Both OSes |
|--------|-----|-----------|
| Switch to 1-9 | Super/Hyper + 1-9 | ✓ |
| Prev workspace | Super/Hyper + G | ✓ |
| Next workspace | Super/Hyper + ; | ✓ |
| Last workspace | Super/Hyper + Tab | ✓ (Aerospace needs change from `) |
| View all | Super/Hyper + 0 | ✓ |

### Window Actions

| Action | Key | Both OSes |
|--------|-----|-----------|
| Close window | Super/Hyper + Q | ✓ |
| Fullscreen | Super/Hyper + F | ✓ |
| Float toggle | Super/Hyper + Shift + Space | ✓ (Aerospace needs change) |
| Zoom (dwm) | Super + Space | dwm only (master/stack) |

### Application Launchers

| Action | Key | Both OSes |
|--------|-----|-----------|
| Terminal | Super/Hyper + Return | ✓ |
| Terminal + tmux | Super/Hyper + Shift + Return | ✓ (Aerospace needs addition?) |
| Browser | Super/Hyper + W | ✓ |
| Editor (nvim) | Super/Hyper + E | ✓ |
| Vimwiki | Super/Hyper + Shift + E | dwm only (add to Aerospace?) |
| File manager (yazi) | Super/Hyper + R | ✓ |
| Launcher | Super/Hyper + D | ✓ (Raycast / dmenu) |

### Monitors

| Action | Key | Status |
|--------|-----|--------|
| Focus next monitor | Super/Hyper + N | CHANGE (dwm from `.`, Aero from `N`) |
| Focus prev monitor | Super/Hyper + P | CHANGE (dwm from `,`, Aero from `P`) |
| Send to next monitor | Super/Hyper + Shift + N | CHANGE |
| Send to prev monitor | Super/Hyper + Shift + P | CHANGE |

### Move Mode (Keychord)

| Sequence | Action | Status |
|----------|--------|--------|
| Super/Hyper + M, then 1-9 | Send window to workspace | ADD to dwm (keychord patch) |
| Super/Hyper + M, then HJKL | Move window | Aerospace only |

Requires **keychord patch** for dwm: https://dwm.suckless.org/patches/keychord/

---

## dwm-Specific Bindings

### Layouts (Consolidated)

Keep these layouts:
- Tile (T)
- Bstack (Shift + T)
- Monocle (Y)
- Deck (Shift + Y)
- CenteredMaster (U)
- CFloatingMaster (Shift + U)

Drop these:
- Grid (was Y)
- Nrowgrid (was Shift + Y)
- layout[8] (was Shift + F)

### Stack/Master Controls

| Action | Key | Keep? |
|--------|-----|-------|
| Focus stack down | J | Yes |
| Focus stack up | K | Yes |
| Push down in stack | Shift + J | Yes |
| Push up in stack | Shift + K | Yes |
| Focus master | V | Yes |
| Resize master - | H | Yes |
| Resize master + | L | Yes |
| Cfact + | Shift + H | Yes |
| Cfact - | Shift + L | Yes |
| Cfact reset | ' | Yes |
| Inc nmaster | I | Yes (moved from O) |
| Dec nmaster | Shift + I | Yes |

### Tag Features (dwm-only)

| Action | Current | Proposed |
|--------|---------|----------|
| toggleview | Ctrl + 1-9 | Mode: C then 1-9? Or keep Ctrl |
| toggletag | Ctrl + Shift + 1-9 | DROP (similar to toggleview) |

Decision: Keep **toggleview** (view multiple tags at once), drop **toggletag**.

### Gaps

| Action | Key | Keep? |
|--------|-----|-------|
| Toggle gaps | Z | Yes (moved from S) |
| Adjust gaps | — | DROP (rarely used) |

### Screenshots

| Action | Key | Change |
|--------|-----|--------|
| Screenshot (gui) | S | CHANGE from P |
| Screenshot (full) | Shift + S | CHANGE from Shift + P |

---

## Freed Keys (Available for New Uses)

| Key | Was | Now |
|-----|-----|-----|
| A | Pulsemixer/Cider | FREE |
| X | Gap adjust | **Clipboard history** (Raycast / clipmenu) |
| , | Monitor prev | FREE |
| . | Monitor next | FREE |
| O | nmaster | FREE (moved to I) |
| Shift + F | layout[8] | FREE |

---

## Items Moved to dmenu/Raycast

| Feature | Was | Now |
|---------|-----|-----|
| Mount drives | Super + M | dmenu script (TODO) |
| Unmount drives | Super + Shift + M | dmenu script (TODO) |
| Audio apps | Super + A | DROP / dmenu |
| Password manager | Super + Shift + D | Keep or Raycast? |

---

## Pending Tasks

1. **Move mount/unmount to dmenu** - create dmenu script
2. **Review dmenupass implementation** - understand how it works
3. **Review cross-platform applications** - music player, browser choices for macOS/Linux/Windows
4. **Implement Aerospace changes**:
   - Change ` to Tab for last workspace
   - Change Space to Shift+Space for float toggle
   - Add N/P for monitors
   - Consider Raycast integration
5. **Implement dwm changes**:
   - Add keychord patch for move mode
   - Change monitors from ,/. to N/P
   - Consolidate layouts
   - Move screenshot to S
   - Free up keys
6. **Design Raycast keybindings** - TBD
7. **Redesign Planck layout** - based on final unified scheme

---

## Raycast / Utilities (macOS + Linux equivalents)

| Key | macOS (Raycast) | Linux |
|-----|-----------------|-------|
| Hyper + D | Raycast launcher | dmenu |
| Hyper + X | Clipboard history | clipmenu (TODO: set up) |
| Hyper + Space | Raycast root / file search | — (dwm uses for zoom) |
| Hyper + Shift + D | ??? | dmenupass |

Note: `Hyper + Space` is macOS-only (Raycast). On Linux, `Super + Space` = zoom (swap with master).

## Open Questions

1. **toggleview mode key**: Use C? Or keep Ctrl+1-9?
2. **Freed keys (A, O, etc.)**: Any new uses?
3. **Hyper + Shift + D**: Password manager on both? (Raycast extension / dmenupass)

---

## Reference: Full Proposed Layout

### Top Row (Numbers)

| Key | Super/Hyper | + Shift | + Ctrl |
|-----|-------------|---------|--------|
| 1-9 | Switch workspace | Send window (via M mode) | toggleview |
| 0 | View all | Tag all | — |
| - | Volume down | — | — |
| = | Volume up/Mute | — | — |

### Top Letter Row (QWERTY...)

| Key | Super/Hyper | + Shift |
|-----|-------------|---------|
| Q | Close | Force kill |
| W | Browser | — |
| E | Editor | Vimwiki |
| R | File manager | — |
| T | Tile layout | Bstack |
| Y | Monocle | Deck |
| U | CenteredMaster | CFloatingMaster |
| I | +nmaster | -nmaster |
| O | FREE | FREE |
| P | Monitor prev | Send to prev mon |

### Home Row (ASDF...)

| Key | Super/Hyper | + Shift |
|-----|-------------|---------|
| A | FREE | FREE |
| S | Screenshot | Full screenshot |
| D | Launcher | Password mgr |
| F | Fullscreen | FREE |
| G | Prev workspace | Send + follow prev |
| H | Resize - | Cfact + |
| J | Focus next | Push down |
| K | Focus prev | Push up |
| L | Resize + | Cfact - |
| ; | Next workspace | Send + follow next |
| ' | Cfact reset | Refresh bar |

### Bottom Row (ZXCV...)

| Key | Super/Hyper | + Shift |
|-----|-------------|---------|
| Z | Gaps toggle | — |
| X | Clipboard history | — |
| C | toggleview mode? | — |
| V | Focus master | — |
| B | Bar toggle | Alt tags? |
| N | Monitor next | Send to next mon |
| M | **MOVE MODE** | — |
| , | FREE | FREE |
| . | FREE | FREE |

### Special Keys

| Key | Super/Hyper | + Shift |
|-----|-------------|---------|
| Return | Terminal | Terminal + tmux |
| Space | Zoom (dwm) / ??? (Aero) | Float toggle |
| Tab | Last workspace | — |
| Backspace | System menu | Quit WM |
