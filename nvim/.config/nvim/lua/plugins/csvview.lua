-- csvview: CSV/TSV as an aligned table, one colour per column. Columns are
-- coloured with extmarks, which sit above treesitter's csv highlights, so the
-- parser in treesitter.lua can stay.
local filetypes = { "csv", "tsv" }

return {
  {
    "hat0uma/csvview.nvim",
    ft = filetypes,
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle", "CsvViewInfo" },
    keys = {
      { "<leader>uv", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV Table View" },
    },
    opts = {
      view = {
        display_mode = "border",
      },
      -- Only active while the table view is on
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    config = function(_, opts)
      local csvview = require("csvview")
      csvview.setup(opts)

      -- Open delimited files straight into the table view
      local function enable(buf)
        if not csvview.is_enabled(buf) then
          csvview.enable(buf)
        end
      end
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("csvview_auto", { clear = true }),
        pattern = filetypes,
        callback = function(ev)
          enable(ev.buf)
        end,
      })
      -- The buffer whose FileType loaded the plugin
      if vim.tbl_contains(filetypes, vim.bo.filetype) then
        enable(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
