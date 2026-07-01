-- Grammar & style checking with Harper (harper-ls)
-- Rust-based, offline, fast — replaces the old JVM-heavy ltex-ls.
--
-- NOTE: Harper is English-only. For trilingual prose (en/es/fr),
-- `isolateEnglish` attempts to lint only the English spans and skip the
-- rest. It is experimental upstream — if it misbehaves on mixed-language
-- passages, toggle Harper off with <leader>lg or set isolateEnglish = false.
--
-- Harper reuses the native spellfile as its user dictionary, so any word
-- added with `zg` is also accepted by Harper.

local user_dict = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "harper_ls", -- Grammar & style (Harper)
        "pyright", -- Python
        "lua_ls", -- Lua
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
          -- Cover both markdown source and vimwiki buffers (palimpsest)
          filetypes = { "markdown", "text", "plaintext", "tex", "vimwiki" },
          settings = {
            ["harper-ls"] = {
              dialect = "Canadian",
              -- Reuse the existing custom spell dictionary
              userDictPath = user_dict,
              -- Only lint English in mixed-language documents (experimental upstream)
              isolateEnglish = true,
              -- Keep diagnostics visually quiet; raise to "warning" if too subtle
              diagnosticSeverity = "hint",
              markdown = {
                IgnoreLinkTitle = true,
              },
              linters = {
                -- Fiction-friendly: prose uses fragments, lowercase openings,
                -- dialogue, and deliberately long sentences.
                SentenceCapitalization = false,
                LongSentences = false,
                SpellCheck = true,
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
