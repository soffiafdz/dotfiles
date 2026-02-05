-- Linting configuration for writing
-- NOTE: vale and write-good require manual installation:
--   brew install vale
--   npm install -g write-good

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
      -- Linters by filetype
      linters_by_ft = {
        markdown = { "vale", "write_good" },
        text = { "vale", "write_good" },
        vimwiki = { "vale", "write_good" },
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

      -- Initialize toggle flags (disabled by default)
      vim.g.vale_enabled = false
      vim.g.write_good_enabled = false

      -- Auto-lint on these events, but respect toggle flags
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          local ft = vim.bo.filetype
          local linters_for_ft = lint.linters_by_ft[ft] or {}
          local enabled_linters = {}

          for _, linter in ipairs(linters_for_ft) do
            if linter == "vale" and vim.g.vale_enabled then
              table.insert(enabled_linters, linter)
            elseif linter == "write_good" and vim.g.write_good_enabled then
              table.insert(enabled_linters, linter)
            elseif linter ~= "vale" and linter ~= "write_good" then
              -- Other linters run unconditionally
              table.insert(enabled_linters, linter)
            end
          end

          if #enabled_linters > 0 then
            require("lint").try_lint(enabled_linters)
          end
        end,
      })
    end,
  },
}
