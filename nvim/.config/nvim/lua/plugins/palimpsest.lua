-- Local Palimpsest project integration
local palimpsest_path = vim.fn.expand("~/Documents/palimpsest")
if vim.fn.isdirectory(palimpsest_path .. "/nvim") == 1 then
  return {
    {
      "palimpsest/local",
      name = "palimpsest.nvim",
      dir = palimpsest_path .. "/nvim",
      dependencies = { "vimwiki/vimwiki" },
      config = function()
        require("palimpsest").setup()
      end,
    },
  }
else
  return {}
end
