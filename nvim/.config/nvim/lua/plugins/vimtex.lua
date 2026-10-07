-- Vimtex
return {
  {
    "lervag/vimtex",
    -- Override config
    config = function()
      vim.g.vimtex_view_method = "sioyek"
      -- macOS installs it as an app bundle, never on $PATH
      if vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_sioyek_exe = "/Applications/sioyek.app/Contents/MacOS/sioyek"
      end
      vim.g.vimtex_compiler_method = "tectonic"
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
