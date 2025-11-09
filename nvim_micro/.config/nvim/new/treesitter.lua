-- Minimal treesitter config for writerdeck
-- Keep: markdown, python, lua, yaml

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Keep only essential parsers for writerdeck
      opts.ensure_installed = {
        "bash",     -- Shell scripts
        "lua",      -- Neovim config
        "markdown", -- Essential for writing
        "markdown_inline",
        "python",   -- Light scripting
        "vim",      -- Vim config
        "yaml",     -- Config files
      }
      
      -- REMOVED FROM YOUR CONFIG:
      -- "comment", "cpp", "css", "csv", "diff", "dockerfile",
      -- "gitcommit", "gitignore", "gpg", "html", "javascript", 
      -- "json", "julia", "latex", "make", "r", "typst"
      
      return opts
    end,
  },
}
