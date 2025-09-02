-- Vimwiki setup
return {
  {
    "vimwiki/vimwiki",
    event = "BufReadPre",
    -- TODO: Make sure that local keymaps work correctly.
    keys = {
      { "<leader>v", group = "Vimwiki" },

      -- Global mapping (any filetype)
      {
        "<leader>vw",
        "<Plug>VimwikiIndex",
        desc = "Vimwiki Index",
      },
      {
        "<leader>vt",
        "<Plug>VimwikiTabIndex",
        desc = "Vimwiki Index (Tab)",
      },
      {
        "<leader>vl",
        "<Plug>VimwikiDiaryIndex",
        desc = "Vimwiki Log",
      },

      -- Filetype-restricted mappings
      {
        "<leader>vt",
        "<Plug>VimwikiMakeDiaryNote",
        desc = "Vimwiki Log (Today)",
        ft = { "vimwiki" },
      },
      {
        "<leader>vr",
        "<Plug>VimwikiDiaryGenerateLinks",
        desc = "Rebuild log links",
        ft = { "vimwiki" },
      },
    },
    config = function()
      vim.g.vimwiki_key_mappings = {
        global = 0,
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
