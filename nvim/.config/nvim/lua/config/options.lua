-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Multilingual spell-checking for trilingual prose (en/es/fr).
-- A word valid in ANY listed language is accepted, which removes the
-- cross-language false positives that made grammar checkers unusable.
-- The es/fr spell files are bundled in spell/ so this works on a fresh machine.
vim.opt.spelllang = { "en", "es", "fr" }
