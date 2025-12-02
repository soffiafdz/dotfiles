-- Local Palimpsest project integration
local palimpsest_path = vim.fn.expand("~/Palimpsest")
if vim.fn.isdirectory(palimpsest_path .. "/dev") == 1 then
  return {
    {
      "palimpsest/local",
      name = "palimpsest.nvim",
      dir = palimpsest_path .. "/dev",
      dependencies = { "vimwiki/vimwiki" },
      config = function()
        require("palimpsest").setup()
      end,
    },
  }
else
  return {}
end
