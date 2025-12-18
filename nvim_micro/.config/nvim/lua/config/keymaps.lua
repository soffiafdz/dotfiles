-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local wk = require("which-key")

wk.add({
  {
    group = "LSP/Grammar",
    icon = { icon = "󱆨", color = "orange" },
    { "<leader>l", group = "LSP/Grammar" },

    -- LSP grammar checking
    {
      "<leader>lg",
      function()
        local clients = vim.lsp.get_clients({ name = "ltex_plus" })
        if #clients > 0 then
          vim.cmd("LspStop ltex_plus")
          -- Disable autostart for ltex
          vim.g.ltex_enabled = false
          vim.notify("ltex stopped", vim.log.levels.INFO)
        else
          -- Enable autostart for ltex
          vim.g.ltex_enabled = true
          vim.cmd("LspStart ltex_plus")
          vim.notify("ltex started", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle ltex grammar",
      icon = "󰓆",
    },
  },
})
