-- Vimwiki setup
return {
  {
    "vimwiki/vimwiki",
    event = "BufReadPre",
    -- TODO: Make sure that local keymaps work correctly.
    keys = {
      { "<leader>v", group = "Vimwiki" },
      -- Global mapping (any filetype)
      { "<leader>vw", "<Plug>VimwikiIndex", desc = "Index", mode = "n" },
      -- Filetype-restricted mappings
      {
        "<leader>vt",
        "<Plug>VimwikiTabIndex",
        desc = "Tab Index",
        mode = "n",
        ft = { "vimwiki" },
      },
      {
        "<leader>vd",
        "<Plug>VimwikiMakeDiaryNote",
        desc = "Diary Today",
        mode = "n",
        ft = { "vimwiki" },
      },
      {
        "<leader>vs",
        "<Plug>VimwikiDiaryGenerateLinks",
        desc = "Rebuild Links",
        mode = "n",
        ft = { "vimwiki" },
      },
    },
    config = function()
      vim.g.vimwiki_global_ext = 0
    end,
  },
}
