# Sioyek + Zotero + SyncTeX Setup

## Sioyek Config Location

Config files in `sioyek/.config/sioyek/`:
- `prefs_user.config` - Main preferences
- `keys_user.config` - Custom keybindings

Use stow to activate:
```bash
cd ~/Developer/dotfiles
stow sioyek
```

---

## Zotero Integration

**Set Sioyek as default PDF reader:**

1. Open Zotero
2. Preferences/Settings → General
3. "Open PDFs using" → Choose custom
4. Navigate to `/Applications/Sioyek.app`

Now double-clicking PDFs in Zotero opens them in Sioyek.

---

## SyncTeX for Quarto/LaTeX

**What is SyncTeX?**
Bidirectional navigation between PDF and source:
- Click in PDF → jumps to that line in source
- From editor → jump to PDF location

**How it works:**

### Forward Search (Source → PDF)

From nvim with VimTeX:
```vim
" In your .qmd or .tex file
:VimtexView
" Or default mapping: <leader>lv
```

### Inverse Search (PDF → Source)

**Already configured** in `prefs_user.config`:
```
inverse_search_command kitty nvim +%2 %1
```

**How to use:**
1. In Sioyek, right-click or use designated key
2. Select "Forward Search" or use shortcut
3. nvim opens at that line

---

## Quarto Workflow

**1. Create a Quarto document:**
```bash
# example.qmd
---
title: "My Document"
format: pdf
---

# Introduction

Some text here.
```

**2. Render with SyncTeX:**
```bash
quarto render example.qmd
```

This creates:
- `example.pdf` - The PDF
- `example.synctex.gz` - SyncTeX data (automatic)

**3. Open PDF in Sioyek:**
```bash
sioyek example.pdf
```

**4. Use SyncTeX:**
- **PDF → Source**: Right-click in PDF → shows line in nvim
- **Source → PDF**: From nvim with VimTeX: `:VimtexView`

---

## VimTeX Configuration

Add to your nvim config for Quarto support:

```lua
-- In your nvim config
vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_view_sioyek_exe = '/Applications/Sioyek.app/Contents/MacOS/sioyek'

-- For Quarto files, enable VimTeX
vim.api.nvim_create_autocmd("FileType", {
  pattern = "quarto",
  callback = function()
    vim.bo.filetype = "tex"  -- Treat as LaTeX for VimTeX
  end,
})
```

Or simpler for Quarto - use Quarto's built-in preview:
```bash
quarto preview example.qmd
```

---

## Alternative: Simple PDF → Source Jump

If VimTeX setup is complex, use the simple command in `prefs_user.config`:

```
inverse_search_command kitty nvim +%2 %1
```

This opens nvim at the correct line when you inverse-search from PDF.

**To test:**
1. Open PDF in Sioyek
2. Right-click (or Ctrl+Click)
3. nvim should open at corresponding line

---

## Troubleshooting

**Inverse search not working:**
- Check Sioyek config: `~/.config/sioyek/prefs_user.config`
- Verify command: `kitty nvim +10 test.qmd` (should open at line 10)
- Make sure SyncTeX file exists (`.synctex.gz`)

**VimTeX not working with Quarto:**
- Quarto uses Pandoc, not LaTeX directly
- Use `quarto preview` for live preview instead
- Or render to PDF first, then use inverse search

**Forward search (nvim → PDF) not working:**
- VimTeX works best with pure LaTeX
- For Quarto, use inverse search (PDF → nvim) primarily
- Or use `quarto preview` for live updates
