local css = vim.fn.stdpath("config") .. "/markdown-preview.css"

return {
  {
    "iamcco/markdown-preview.nvim",
    init = function()
      vim.g.mkdp_markdown_css = css
    end,
  },
}
