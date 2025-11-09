# Writerdeck LazyVim Configuration
## Simplified version of your existing config for Raspberry Pi Zero 2W

This removes unnecessary plugins from your main config while keeping everything you need for writing.

## What's Disabled

### Language Support Removed
- ❌ R.nvim (you won't code R on writerdeck)
- ❌ Quarto/Otter (related to R)
- ❌ Docker language support
- ❌ Git language support extras
- ❌ LaTeX/VimTeX (unless you need it?)
- ❌ TOML support
- ❌ Julia, TypeScript, CSS, HTML parsers

### UI Plugins Disabled
- ❌ Noice.nvim (heavy command line UI)
- ❌ Notify (notifications)
- ❌ Dressing (UI enhancements)
- ❌ Flash.nvim (motion plugin)
- ❌ Indent-blankline
- ❌ Trouble.nvim
- ❌ Todo-comments
- ❌ Persistence (sessions)

### Git Integration Disabled
- ❌ Gitsigns
- ❌ Vim-fugitive

## What's Kept (What You Need)

### Language Support
- ✅ **ltex_plus** - Grammar checking (your existing config!)
- ✅ **Markdown** - Full support with preview
- ✅ **Python** - pyright LSP + black formatting
- ✅ **Lua** - lua_ls for config editing
- ✅ **YAML** - Basic support
- ✅ **Vimwiki** - Your existing setup

### Essential Plugins
- ✅ nvim-cmp with LuaSnip
- ✅ Telescope
- ✅ Mini.comment, Mini.surround, Mini.pairs
- ✅ Gruvbox theme
- ✅ Your spell dictionary

### Treesitter Parsers
```lua
-- Only these 7 instead of your 24:
"bash", "lua", "markdown", "markdown_inline", "python", "vim", "yaml"
```

## Installation

### Option 1: Replace Your Config Files

```bash
# Backup first!
cp ~/.config/nvim/lua/config/lazy.lua ~/.config/nvim/lua/config/lazy.lua.backup

# Copy new files
cp lazy.lua ~/.config/nvim/lua/config/lazy.lua
cp ltex-ls.lua ~/.config/nvim/lua/plugins/ltex-ls.lua
cp treesitter.lua ~/.config/nvim/lua/plugins/treesitter.lua
cp disable-plugins.lua ~/.config/nvim/lua/plugins/disable-plugins.lua
```

### Option 2: Just Add Disable File

If you want to keep your existing setup as-is and just disable plugins:

```bash
# Just add the disable file
cp disable-plugins.lua ~/.config/nvim/lua/plugins/disable-plugins.lua
```

Then manually edit `~/.config/nvim/lua/config/lazy.lua` and comment out the extras you don't need.

### Your Existing Plugins to Keep

These should already be in your `lua/plugins/` directory:
- ✅ `gruvbox.lua` - Already configured
- ✅ `vimwiki.lua` - Already configured  
- ✅ `nvim-cmp_supertab.lua` - Keep this
- ✅ `palimpsest.lua` - Keep this (your local project)

### Your Existing Plugins to Remove/Disable

Create these overrides in your plugins directory:
```bash
# Disable R.nvim
echo 'return { "R-nvim/R.nvim", enabled = false }' > ~/.config/nvim/lua/plugins/r-nvim.lua

# Disable Quarto
echo 'return { "quarto-dev/quarto-nvim", enabled = false }' > ~/.config/nvim/lua/plugins/quarto-nvim.lua

# Disable Otter
echo 'return { "jmbuhr/otter.nvim", enabled = false }' > ~/.config/nvim/lua/plugins/otter.lua
```

## After Installation

1. **Open Neovim:**
   ```bash
   nvim
   ```

2. **Let Lazy.nvim update:**
   - It will remove disabled plugins
   - Install any missing ones
   - Update treesitter parsers

3. **Check health:**
   ```vim
   :checkhealth
   ```

4. **Test grammar checking:**
   Open a markdown file and the ltex_plus LSP should start automatically.

## Memory Usage

### Before (Your Full Config)
- ~200-300 MB with all extras

### After (Writerdeck Config)
- ~120-180 MB 
- Grammar checking still works!
- All writing features intact

## Performance Tweaks Already in Your Config

You already have these optimizations:
- Transparent background
- Performance guards for large files
- Auto-save for markdown files
- Vimwiki diary templates

## If You Need More Performance

### Disable LSP Temporarily
Add to your options:
```lua
vim.g.lazyvim_lsp_enabled = false
```

### Reduce ltex Memory
Already reduced to 512MB (was 1GB):
```lua
JAVA_OPTS = "-Xmx512m ..."
```

### Disable Markdown Preview
In your markdown config, set:
```lua
{ "iamcco/markdown-preview.nvim", enabled = false }
```

## What to Do with Your Old Files

### Keep These
- `lua/config/options.lua` - Your settings
- `lua/config/keymaps.lua` - Your keybindings
- `lua/config/autocmds.lua` - Your autocommands
- `lua/plugins/gruvbox.lua` - Colorscheme
- `lua/plugins/vimwiki.lua` - Essential
- `lua/plugins/palimpsest.lua` - Your project
- `lua/plugins/nvim-cmp_supertab.lua` - Completion
- `spell/en.utf-8.add` - Your dictionary

### Replace These
- `lua/config/lazy.lua` - Use new version
- `lua/plugins/ltex-ls.lua` - Use new version (optimized)
- `lua/plugins/treesitter.lua` - Use new version (minimal)

### Remove/Disable These
- `lua/plugins/r-nvim.lua` - Not needed
- `lua/plugins/quarto-nvim.lua` - Not needed
- `lua/plugins/otter.lua` - Not needed

## Verification Checklist

After setup, verify:
- [ ] Neovim starts quickly (< 3 seconds)
- [ ] Can open markdown files
- [ ] Grammar checking works (`:LspInfo` shows ltex_plus)
- [ ] Vimwiki works (`<space>vw`)
- [ ] Python syntax highlighting works
- [ ] Auto-save works for .md files
- [ ] Your spell dictionary loads
- [ ] Memory usage reasonable (`htop`)

## Notes

- **Grammar checking is KEPT** - This was important based on your ltex-ls.lua config
- **Your vimwiki setup is unchanged** - All your diary templates work
- **Your custom keymaps are preserved** - Nothing changes there
- **Gruvbox theme stays** - With transparency

## Re-enabling Features

If you find you need something:

```lua
-- In lua/plugins/disable-plugins.lua, change enabled = false to true:
{ "lewis6991/gitsigns.nvim", enabled = true },  -- Re-enable git signs
```

Or just delete the line to use default.

## Questions?

- LSP not working? Run `:Mason` to check installed servers
- Grammar check not working? Check `:LspInfo` in a markdown file
- Too slow? Consider disabling ltex temporarily (it uses Java)
