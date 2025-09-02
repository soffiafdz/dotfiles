local MiniIcons = require("mini.icons")
local icon_data = MiniIcons.get("extension", ".md")
local wiki_icon = icon_data and icon_data.icon or "󰖬"
return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      table.insert(opts.spec, {
        "<leader>v",
        group = "vimwiki",
        icon = { icon = wiki_icon, color = "green" },
      })
      table.insert(opts.spec, {
        "<leader>vt",
        icon = { icon = wiki_icon, color = "green" },
      })
    end,
  },
}
