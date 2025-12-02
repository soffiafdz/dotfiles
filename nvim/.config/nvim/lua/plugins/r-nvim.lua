-- R.nvim
return {
  "R-nvim/R.nvim",
  version = "0.99.1",
  opts = function(_, opts)
    opts.R_app = "radian" -- Use radian

    -- Open data.frames with vd
    opts.view_df = { open_app = "terminal:vd" }
    -- opts.setwd = true

    -- Conditional adjustments for TMUX
    local tmux = os.getenv("TMUX") ~= nil
    if tmux then
      opts.config_tmux = true
      opts.external_term = "tmux split-window -hf"
      opts.view_df = { open_app = "tmux new-window 80 vd" }
    end

    return opts
  end,
}
