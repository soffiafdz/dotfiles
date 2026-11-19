-- Vimwiki setup
return {
  {
    "vimwiki/vimwiki",
    -- No lazy-loading: vimwiki needs to load at startup for global keymaps
    lazy = false,
    init = function()
      vim.g.vimwiki_map_prefix = "<leader>v"
      -- Must be set before vimwiki loads; otherwise every .md file becomes a
      -- temporary wiki and loses markdown-only plugins and keymaps.
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.vimwiki_list = {
        {
          -- glosa's generated pages: markdown links, .md, home at index/index
          name = "glosa",
          path = "~/.local/share/glosa/views/",
          syntax = "markdown",
          ext = ".md",
          index = "index/index",
          links_space_char = "-",
          auto_diary_index = 0,
          auto_generate_links = 0,
          auto_generate_tags = 0,
          auto_tags = 0,
        },
        {
          name = "Notes",
          path = "~/Documents/wiki/",
          syntax = "markdown",
          ext = ".md",
          links_space_char = "-",
          diary_rel_path = "diary/",
          diary_header = "Diary",
          diary_index = "index",
        },
      }
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

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "vimwiki",
        callback = function()
          vim.keymap.set("n", "<S-CR>", "<Plug>VimwikiVSplitLink", { buffer = true })
        end,
      })

      -- The which-key group of the vimwiki prefix, with its icon. vimwiki
      -- loads at startup, before which-key: registered once everything
      -- lazy has loaded, or the group shows with no icon.
      local function group()
        local has_wk, wk = pcall(require, "which-key")
        if has_wk and wk.add then
          wk.add({
            { "<leader>v", group = "vimwiki", icon = { icon = "󰍔", color = "green" } },
          })
        end
      end
      vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = group })
    end,
  },
}
