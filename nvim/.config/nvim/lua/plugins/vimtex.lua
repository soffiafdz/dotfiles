-- Vimtex
return {
  {
    "lervag/vimtex",
    -- Override config
    config = function()
      vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_compiler_method = "latexmk"
      -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_log_ignore = {
        "Underfull",
        "Overfull",
        "Token not allowed in a PDF string",
      }
    end,
  },
}
