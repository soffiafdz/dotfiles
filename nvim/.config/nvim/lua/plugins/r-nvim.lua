-- R.nvim
return {
  "R-nvim/R.nvim",
  opts = function(_, opts)
    -- Detect environment
    local tmux = os.getenv("TMUX") ~= nil

    opts = opts or {}
    opts.view_df = opts.view_df or {}

    -- Use radian
    opts.R_app = "radian"

    -- Open data.frames with vd
    opts.view_df.open_app = opts.view_df.open_app or "terminal:vd"

    -- Conditional adjustments
    if tmux then
      opts.config_tmux = true
      opts.external_term = "tmux split-window -hf"
      opts.view_df.open_app = "tmux new-window 80 vd"
    end

    return opts
  end,
}
