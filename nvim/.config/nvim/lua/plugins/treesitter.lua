-- Add more parsers
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "comment",
        "cpp",
        "css",
        "csv",
        "dockerfile",
        "gitcommit",
        "gitignore",
        "gpg",
        "julia",
        "make",
        "typst",
      })
    end,
  },
}
