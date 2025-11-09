-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

-- Toggle ltex LSP on/off
vim.keymap.set("n", "<leader>lg", function()
  local clients = vim.lsp.get__clients({ name = "ltex" })
  if #clients > 0 then
    vim.cmd("LspStop ltex")
    vim.notify("ltex stopped", vim.log.levels.INFO)
  else
    vim.cmd("LspStart ltex")
    vim.notify("ltex started", vim.log.levels.INFO)
  end
end, { desc = "Toggle ltex grammar checking" })

-- Manual lint trigger
vim.keymap.set("n", "<leader>ll", function()
  require("lint").try_lint()
  vim.notify("Linting...", vim.log.levels.INFO)
end, { desc = "Lint current file" })

-- Lint with specific linter
vim.keymap.set("n", "<leader>lv", function()
  require("lint").try_lint("vale")
  vim.notify("Running vale...", vim.log.levels.INFO)
end, { desc = "Lint with vale" })

vim.keymap.set("n", "<leader>lw", function()
  require("lint").try_lint("write_good")
  vim.notify("Running write-good...", vim.log.levels.INFO)
end, { desc = "Lint with write-good" })
