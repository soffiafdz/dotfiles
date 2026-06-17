-- Linting configuration
-- Prose grammar/style is handled by Harper (see harper.lua); this is just
-- structural linting for config files.

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "yamllint",
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
