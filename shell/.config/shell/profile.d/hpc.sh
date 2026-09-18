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

# Module versions differ per cluster and change over time, so they live
# outside the repo too: ~/.config/hpc/modules, e.g.
#     R_MODULE=r/4.6.1
#     PY_MODULE=python/3.13
#     STDENV=StdEnv/2023
_mod_file="${XDG_CONFIG_HOME:-$HOME/.config}/hpc/modules"
# shellcheck source=/dev/null
[ -r "$_mod_file" ] && . "$_mod_file"
export STDENV="${STDENV:-StdEnv/2023}"
export R_MODULE="${R_MODULE:-r}"
export PY_MODULE="${PY_MODULE:-python}"
unset _mod_file

# Slurm aliases, salloc/module helpers and the job templates.
_hpc_env="${XDG_CONFIG_HOME:-$HOME/.config}/hpc/env.sh"
[ -r "$_hpc_env" ] && . "$_hpc_env"
unset _hpc_env
