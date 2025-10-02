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
  additionalRules = { motherTongue = "es" }
end

-- Use built in dictionary
local words = {}
local dict_file = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")
if vim.fn.filereadable(dict_file) == 1 then
  for word in io.open(dict_file, "r"):lines() do
    table.insert(words, word)
  end
end

return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ltex" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex = {
          filetypes = { "markdown", "tex", "text", "plaintext", "vimwiki" },
          cmd_env = {
            JAVA_OPTS = "-Xmx1g -Djdk.xml.totalEntitySizeLimit=0 -Djdk.xml.entityExpansionLimit=0",
          },
          settings = {
            ltex = {
              language = "en-CA",
              additionalRules = additionalRules,
              dictionary = {
                ["en-CA"] = words,
              },
              disabledRules = {
                ["en-CA"] = {
                  "WHITESPACE_RULE",
                  "ENGLISH_WORD_REPEAT_BEGINNING_RULE",
                  "MORFOLOGIK_RULE_EN_CA",
                  "WANNA",
                  "ARROWS",
                  "IDK",
                },
                ["es"] = { "WHITESPACE_RULE" },
                ["fr"] = { "WHITESPACE_RULE" },
              },
              -- trace = { server = "verbose" },
            },
          },
        },
      },
    },
  },
}
