-- Vimwiki setup
return {
  {
    "vimwiki/vimwiki",
    -- No lazy-loading: vimwiki needs to load at startup for global keymaps
    lazy = false,
    init = function()
      vim.g.vimwiki_map_prefix = "<leader>v"
    end,
    -- TODO: Make sure that local keymaps work correctly.

    -- keys = {
    --   -- Global mapping (any filetype)
    --   {
    --     "<leader>vw",
    --     "<Plug>VimwikiIndex",
    --     desc = "Vimwiki Index",
    --   },
    --   {
    --     "<leader>vt",
    --     "<Plug>VimwikiTabIndex",
    --     desc = "Vimwiki Index (New tab)",
    --   },
    --   {
    --     "<leader>vl",
    --     "<Plug>VimwikiDiaryIndex",
    --     desc = "Vimwiki Log",
    --   },
    --
    --   -- Filetype-restricted mappings
    --   {
    --     "<leader>v<leader>w",
    --     "<Plug>VimwikiMakeDiaryNote",
    --     desc = "Vimwiki Log (Today)",
    --     ft = { "vimwiki" },
    --   },
    --   {
    --     "<leader>v<leader>t",
    --     "<Plug>VimwikiTabMakeDiaryNote",
    --     desc = "Palimpsest Log (Today, new tab)",
    --     ft = { "vimwiki" },
    --   },
    --   {
    --     "<leader>vr",
    --     "<Plug>VimwikiDiaryGenerateLinks",
    --     desc = "Rebuild log links",
    --     ft = { "vimwiki" },
    --   },
    -- },
    config = function()
      vim.g.vimwiki_key_mappings = {
        table_format = 0,
        table_mappings = 0,
        html = 0,
      }
      vim.g.vimwiki_global_ext = 0
      vim.g.ext2syntax = {}
      vim.g.vimwiki_markdown_link_ext = 1
    end,
  },
}
