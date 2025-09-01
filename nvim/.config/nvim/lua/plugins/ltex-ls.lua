-- ltex.lua integration
--[[
To use different a language in Markdown,
it is necessary to use magic comments: 
  <!-- LTeX: language-es -->
  <!-- LTeX: language-en-CA -->
  <!-- LTeX: language-fr -->
--]]
-- Conditionally load ngrams
local ngrams_path = vim.fn.expand("~/.local/share/nvim/models/ngrams/")
local additionalRules
if vim.fn.isdirectory(ngrams_path) == 1 then
  additionalRules = {
    motherTongue = "es",
    languageModel = ngrams_path,
  }
else
  additionalRules = { motherTonge = "es" }
end

return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ltex" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          filetypes = { "markdown", "tex", "text" },
          settings = {
            language = "en-CA",
            additionalRules = additionalRules,
          },
        },
      },
    },
  },
}
