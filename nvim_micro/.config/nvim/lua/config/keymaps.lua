-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local linter_icon = ""
local wk = require("which-key")

wk.add({
  {
    group = "Linter",
    icon = { icon = "󱆨", color = "orange" }, -- or use a lint-related icon
    { "<leader>l", group = "Linter" },

    -- LSP grammar checking
    {
      "<leader>lg",
      function()
        local clients = vim.lsp.get_clients({ name = "ltex" })
        if #clients > 0 then
          vim.cmd("LspStop ltex")
          vim.notify("ltex stopped", vim.log.levels.INFO)
        else
          vim.cmd("LspStart ltex")
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

    -- Vale linter
    {
      "<leader>lv",
      function()
        require("lint").try_lint("vale")
        vim.notify("Running vale...", vim.log.levels.INFO)
      end,
      desc = "Lint with vale",
      icon = "󰓆",
    },

    {
      "<leader>lw",
      function()
        require("lint").try_lint("write_good")
        vim.notify("Running write-good...", vim.log.levels.INFO)
      end,
      desc = "Lint with write-good",
      icon = "󰓆",
    },
  },
})
