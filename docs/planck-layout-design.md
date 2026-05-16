# Planck EZ Simplified Layout Design

Based on unified keybindings philosophy. 4 layers only.
Designed for compatibility with WriterDeck Planck.

## Layer Overview

| Layer | Purpose | Access |
|-------|---------|--------|
| BASE | QWERTY + arrows | default |
| LOWER | Symbols + F11-F16 | hold LOWER |
| RAISE | Numbers + F1-F10 | hold RAISE |
| ADJUST | System + Media | LOWER+RAISE |

## BASE Layer

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│ ESC │  Q  │  W  │  E  │  R  │  T  │  Y  │  U  │  I  │  O  │  P  │BSPC │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ TAB │  A  │  S  │  D  │  F  │  G  │  H  │  J  │  K  │  L  │  ;  │  '  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│SHIFT│  Z  │  X  │  C  │  V  │  B  │  N  │  M  │  ,  │  .  │  /  │ENTER│
├─────┼─────┼─────┼─────┼─────┼─────┴─────┼─────┼─────┼─────┼─────┼─────┤
│CTRL │LGUI │LALT │RGUI │LOWER│   SPACE   │RAISE│  ←  │  ↓  │  ↑  │  →  │
└─────┴─────┴─────┴─────┴─────┴───────────┴─────┴─────┴─────┴─────┴─────┘
```

**Key points:**
- LGUI = Super (Linux/dwm)
- RGUI = Right Cmd → Hyper (macOS via Karabiner)
- Arrows on bottom right (matches WriterDeck)

**Comparison with WriterDeck:**
```
WriterDeck: PWR  │Ctrl │Alt  │Cmd  │ ??  │  SPACE  │ ?? │ -  │ ↓  │ ↑  │ →  │
ZSA Planck: CTRL │LGUI │LALT │RGUI │LOWER│  SPACE  │RAISE│ ←  │ ↓  │ ↑  │ →  │
```

## LOWER Layer (Symbols)

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│  ~  │  !  │  @  │  #  │  $  │  %  │  ^  │  &  │  *  │  (  │  )  │ DEL │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ DEL │ F11 │ F12 │ F13 │ F14 │ F15 │ F16 │  _  │  +  │  {  │  }  │  |  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │     │     │     │  <  │  >  │  ?  │     │
├─────┼─────┼─────┼─────┼─────┼─────┴─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │█████│           │     │HOME │PGDN │PGUP │ END │
└─────┴─────┴─────┴─────┴─────┴───────────┴─────┴─────┴─────┴─────┴─────┘
```

**Key points:**
- Shifted symbols on top row (like WriterDeck DOWN layer)
- F11-F16 on home row (matches WriterDeck)
- `{ }` and `|` accessible
- Navigation (Home/PgDn/PgUp/End) on arrow positions

## RAISE Layer (Numbers)

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│  `  │  1  │  2  │  3  │  4  │  5  │  6  │  7  │  8  │  9  │  0  │ DEL │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│ DEL │ F1  │ F2  │ F3  │ F4  │ F5  │ F6  │  -  │  =  │  [  │  ]  │  \  │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │ F7  │ F8  │ F9  │ F10 │     │     │     │  ,  │  .  │  /  │     │
├─────┼─────┼─────┼─────┼─────┼─────┴─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │           │█████│  ←  │  ↓  │  ↑  │  →  │
└─────┴─────┴─────┴─────┴─────┴───────────┴─────┴─────┴─────┴─────┴─────┘
```

**Key points:**
- Numbers on top row (like WriterDeck UPPER layer)
- F1-F10 on home row (matches WriterDeck)
- `[ ]` and `\` accessible
- Arrows stay same position (transparent)

## ADJUST Layer (System + Media)

```
┌─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┬─────┐
│SLEEP│BR_UP│     │     │ RGB │RGBM+│RGB+ │HUE+ │     │     │PSCR │POWER│
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│WAKE │BR_DN│     │     │RGBTG│RGBSL│RGB- │HUE- │     │     │ INS │MUTE │
├─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┼─────┤
│     │     │     │     │     │     │     │     │     │     │     │     │
├─────┼─────┼─────┼─────┼─────┼─────┴─────┼─────┼─────┼─────┼─────┼─────┤
│BOOT │     │     │     │█████│ PLAY/PAUSE│█████│PREV │VOL- │VOL+ │NEXT │
└─────┴─────┴─────┴─────┴─────┴───────────┴─────┴─────┴─────┴─────┴─────┘
```

**Key points:**
- Arrow positions become media: ← PREV │ ↓ VOL- │ ↑ VOL+ │ → NEXT
- Space = Play/Pause (big target)
- MUTE on right side (home row)
- System: Sleep/Wake/Power in corners, Brightness on left
- RGB controls preserved (R row: toggle, mode, brightness, hue)
- BOOT for firmware flashing

## Layer Comparison: ZSA Planck vs WriterDeck

| Feature | ZSA Planck | WriterDeck |
|---------|------------|------------|
| Numbers | RAISE + QWERTY row | UPPER + QWERTY row |
| Symbols | LOWER + QWERTY row | DOWN + QWERTY row |
| F1-F10 | RAISE + home row | UPPER + home row |
| F11-F16 | LOWER + home row | DOWN + home row |
| Arrows | BASE bottom right | BASE bottom right |
| Nav | LOWER bottom right | (varies) |
| Left mods | CTRL LGUI LALT RGUI | PWR CTRL ALT CMD |

## Dropped from Original

- ~~Mouse layer~~ (use actual mouse)
- ~~Numpad layer~~ (never used)
- ~~Separate media layer~~ (merged into ADJUST)
- ~~DUAL_FUNC shift/alt~~ (simpler regular shift)

## WM Usage

For window manager shortcuts:
- **Linux (dwm):** Hold LGUI + keys
- **macOS (Aerospace):** Hold RGUI (→ Hyper via Karabiner) + keys

Both GUI keys are in comfortable thumb positions.

**Note:** WriterDeck doesn't need RGUI since it runs a single terminal with no windows to manage.
