-- Grammar checking with ltex_plus (from your config)
-- Keep this for writing tasks

-- Conditionally load ngrams if available
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

-- Load built-in dictionary
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
      ensure_installed = { 
        "ltex_plus",  -- Grammar checking
        "pyright",    -- Python
        "lua_ls",     -- Lua
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ltex_plus = {
          filetypes = { "markdown", "text", "plaintext", "vimwiki" },
          cmd_env = {
            -- Reduced memory for Pi Zero 2W
            JAVA_OPTS = "-Xmx512m -Djdk.xml.totalEntitySizeLimit=0 -Djdk.xml.entityExpansionLimit=0",
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
            },
          },
        },
        -- Minimal Python support
        pyright = {},
        -- Minimal Lua support
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
            },
          },
        },
      },
    },
  },
}
