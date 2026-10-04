-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local has_wk, wk = pcall(require, "which-key")
if not has_wk then
  return
end

local has_icons, MiniIcons = pcall(require, "mini.icons")
local keywordprg_icon = has_icons and MiniIcons.get("filetype", "help") or ""

wk.add({
  -- Keywordprg
  { "<leader>K", icon = { icon = keywordprg_icon, color = "cyan" } },
  {
    group = "Linter",
    icon = { icon = "󱆨", color = "orange" }, -- or use a lint-related icon
    { "<leader>l", group = "Linter" },

    -- LSP grammar checking
    {
      "<leader>lg",
      function()
        local on = not vim.lsp.is_enabled("harper_ls")
        vim.lsp.enable("harper_ls", on)
        vim.notify(on and "Harper started" or "Harper stopped", vim.log.levels.INFO)
      end,
      desc = "Toggle Harper grammar",
      icon = "󰓆",
    },

    -- General linting
    {
      "<leader>ll",
      function()
        require("lint").try_lint()
        vim.notify("Linting...", vim.log.levels.INFO)
      end,
      desc = "Lint current file",
      icon = "󰁨",
    },
  },
})
