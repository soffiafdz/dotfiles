-- Local Palimpsest project integration — writerdeck (no-Python) variant.
-- Loads palimpsest_deck.nvim from dev/lua-deck/, which contains only
-- the pure-Lua surface (vimwiki, fzf browse/search, YAML float editor).
-- No `plm` is invoked; sync happens on the main machine.
local palimpsest_path = vim.fn.expand("~/Palimpsest")
if vim.fn.isdirectory(palimpsest_path .. "/dev/lua-deck") == 1 then
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
