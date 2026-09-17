-- The Pi has no ~/Documents/wiki and palimpsest_deck registers its own wiki,
-- so replace the main config's init (which sets vimwiki_list) with the
-- prefix alone. Everything else in the main vimwiki spec still applies.
return {
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_map_prefix = "<leader>v"
    end,
  },
}
