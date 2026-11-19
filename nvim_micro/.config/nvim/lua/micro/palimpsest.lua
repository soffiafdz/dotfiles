-- Local Palimpsest project integration — writerdeck (no-Python) variant.
-- Loads palimpsest_deck.nvim from dev/lua-deck/, which contains only
-- the pure-Lua surface (vimwiki, fzf browse/search, YAML float editor).
-- No `plm` is invoked; sync happens on the main machine.
--
-- Superseded by glosa: once ~/Repos/glosa exists on the deck, the main
-- config's plugins/glosa.lua loads its plugin and this loads nothing.
local palimpsest_path = vim.fn.expand("~/Palimpsest")
local has_glosa = vim.fn.isdirectory(vim.fn.expand("~/Repos/glosa/editor/nvim")) == 1
if not has_glosa and vim.fn.isdirectory(palimpsest_path .. "/dev/lua-deck") == 1 then
  return {
    {
      "palimpsest/local",
      name = "palimpsest_deck.nvim",
      dir = palimpsest_path .. "/dev/lua-deck",
      dependencies = { "vimwiki/vimwiki" },
      config = function()
        require("palimpsest_deck").setup()
      end,
    },
  }
else
  return {}
end
