#!/bin/sh
# Alliance clusters (Rorqual, Trillium). Sourced by shell/profile when
# $CC_CLUSTER is set. No GUI here: no TERMINAL, READER or BROWSER.

# nvim is a user install (see hpc-setup); fall back to the system vim.
command -v nvim >/dev/null || export EDITOR="vim"
unset READER BROWSER TERMINAL

# Slurm reads these, so --account can be left off sbatch/salloc/srun.
# The account lives outside the repo: echo def-<pi> > ~/.config/hpc/account
_acct_file="${XDG_CONFIG_HOME:-$HOME/.config}/hpc/account"
if [ -r "$_acct_file" ]; then
	SBATCH_ACCOUNT="$(cat "$_acct_file")"
	SALLOC_ACCOUNT="$SBATCH_ACCOUNT"
	SRUN_ACCOUNT="$SBATCH_ACCOUNT"
	export SBATCH_ACCOUNT SALLOC_ACCOUNT SRUN_ACCOUNT
fi
unset _acct_file

# Slurm aliases, salloc/module helpers and the job templates.
_hpc_env="${XDG_CONFIG_HOME:-$HOME/.config}/hpc/env.sh"
[ -r "$_hpc_env" ] && . "$_hpc_env"
unset _hpc_env
