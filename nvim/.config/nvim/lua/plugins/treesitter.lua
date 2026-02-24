-- Add more parsers
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.prefer_git = true
      opts.ensure_installed = opts.ensure_installed or {}
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
