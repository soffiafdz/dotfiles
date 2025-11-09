-- Minimal treesitter config
-- Keep: markdown, python, lua, yaml

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.prefer_git = true
      -- Keep only essential parsers for writerdeck
      opts.ensure_installed = {
        "bash", -- Shell scripts
        "lua", -- Neovim config
        "markdown", -- Essential for writing
        "markdown_inline",
        "python", -- Light scripting
        "tex",
        "typst",
        "vim", -- Vim config
        "yaml", -- Config files
      }
      return opts
    end,
  },
}
