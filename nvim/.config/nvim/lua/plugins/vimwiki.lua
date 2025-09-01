-- Vimwiki setup
return {
  {
    "vimwiki/vimwiki",
    event = "BufReadPre",
    -- TODO: Make sure that local keymaps work correctly.
    keys = {
      {
        "<leader>v",
        name = "Vimwiki", -- Which-Key group name
        mode = "n",
        { "i", "<Plug>VimwikiIndex", desc = "Index" },
        { "t", "<Plug>VimwikiTabIndex", desc = "Tab Index" },
        { "d", "<Plug>VimwikiMakeDiaryNote", desc = "Diary Today" },
        { "s", "<Plug>VimwikiDiaryGenerateLinks", desc = "Rebuild Links" },
      },
    },
    config = function()
      vim.g.vimwiki_global_ext = 0
    end,
  },
}
