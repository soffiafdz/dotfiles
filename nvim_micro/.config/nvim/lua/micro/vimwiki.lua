-- The Pi has no ~/Documents/wiki, so the main config's wiki list is
-- replaced. With glosa on the deck its pages are the one wiki; before
-- that, palimpsest_deck registers its own and only the prefix is set.
-- Everything else in the main vimwiki spec still applies.
return {
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_map_prefix = "<leader>v"
      local views = vim.fn.expand("~/.local/share/glosa/views")
      if vim.fn.isdirectory(views) == 1 then
        vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_markdown_link_ext = 1
        vim.g.vimwiki_list = {
          {
            name = "glosa",
            path = views .. "/",
            syntax = "markdown",
            ext = ".md",
            index = "index/index",
            links_space_char = "-",
            auto_diary_index = 0,
            auto_generate_links = 0,
            auto_generate_tags = 0,
            auto_tags = 0,
          },
        }
      end
    end,
  },
}
