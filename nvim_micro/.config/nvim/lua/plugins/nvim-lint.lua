-- Linting configuration for microjournal

return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Linters by filetype
      linters_by_ft = {
        markdown = { "vale" },
        text = { "vale" },
        vimwiki = { "vale" },
        yaml = { "yamllint" },
      },

      -- Linters to run on all files (optional)
      -- linters_by_ft = {
      --   ['*'] = { 'vale' },
      -- },
    },
    config = function(_, opts)
      local lint = require("lint")

      -- Set linters
      lint.linters_by_ft = opts.linters_by_ft

      -- Auto-lint on these events
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
