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

      -- Set default icons for vimwiki group (palimpsest will override when active)
      local has_wk, wk = pcall(require, "which-key")
      if has_wk then
        local has_icons, MiniIcons = pcall(require, "mini.icons")
        local vimwiki_icon = has_icons and MiniIcons.get("extension", "md") or ""
        wk.add({
          { "<leader>v", group = "vimwiki", icon = { icon = vimwiki_icon, color = "green" } },
        })
      end
    end,
  },
}
