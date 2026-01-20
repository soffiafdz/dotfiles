-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local linter_icon = ""
local wk = require("which-key")
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

    -- Vale linter toggle
    {
      "<leader>lv",
      function()
        vim.g.vale_enabled = not vim.g.vale_enabled
        if vim.g.vale_enabled then
          require("lint").try_lint("vale")
          vim.notify("vale enabled", vim.log.levels.INFO)
        else
          -- Clear vale diagnostics when disabling
          local lint = require("lint")
          local ns = lint.get_namespace("vale")
          vim.diagnostic.reset(ns)
          vim.notify("vale disabled", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle vale linter",
      icon = "󰓆",
    },

    -- Write-good linter toggle
    {
      "<leader>lw",
      function()
        vim.g.write_good_enabled = not vim.g.write_good_enabled
        if vim.g.write_good_enabled then
          require("lint").try_lint("write_good")
          vim.notify("write-good enabled", vim.log.levels.INFO)
        else
          -- Clear write_good diagnostics when disabling
          local lint = require("lint")
          local ns = lint.get_namespace("write_good")
          vim.diagnostic.reset(ns)
          vim.notify("write-good disabled", vim.log.levels.INFO)
        end
      end,
      desc = "Toggle write-good linter",
      icon = "󰓆",
    },
  },
})
