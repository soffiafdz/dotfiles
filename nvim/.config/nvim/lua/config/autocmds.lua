-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Autosave prose buffers so long writing sessions never lose work.
-- Only fires for real, writable files of prose filetypes.
local grp = vim.api.nvim_create_augroup("prose_autosave", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave", "InsertLeave", "CursorHold" }, {
  group = grp,
  callback = function(ev)
    local b = ev.buf
    if
      vim.bo[b].modified
      and vim.bo[b].buftype == ""
      and not vim.bo[b].readonly
      and vim.fn.filereadable(vim.api.nvim_buf_get_name(b)) == 1
      and vim.tbl_contains({ "markdown", "vimwiki", "text", "tex", "quarto" }, vim.bo[b].filetype)
    then
      vim.api.nvim_buf_call(b, function()
        vim.cmd("silent! noautocmd update")
      end)
    end
  end,
})
