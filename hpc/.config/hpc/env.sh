#!/bin/sh
# Slurm helpers for Alliance clusters. Sourced by shell/profile.d/hpc.sh,
# so the aliases and functions reach the interactive shell too.
#
# $SBATCH_ACCOUNT / $SALLOC_ACCOUNT are set from ~/.config/hpc/account, so
# nothing here needs --account.

# --- Queue and accounting -------------------------------------------------
alias sq='squeue -u "$USER" -o "%.10i %.9P %.24j %.2t %.10M %.10L %.4C %.8m %R"'
alias sqs='squeue -u "$USER" --start'          # estimated start times
alias sqa='squeue -u "$USER" --array'          # one line per array task
alias scq='scancel -i -u "$USER"'              # cancel everything, -i asks per job
# No -X and no MaxRSS here: MaxRSS is recorded per step, so it is always blank
# on allocation lines. Use `seff <jobid>` for what a job actually used.
alias sj='sacct -X -o JobID,JobName%24,State,Elapsed,ReqMem,CPUTime'
alias sme='sshare -U -u "$USER"'               # fair-share / priority

# Disk and file-count quotas: the file count bites before the space does.
alias quota='diskusage_report'

# Same name as the BIC helper, so the muscle memory carries over.
alias _tmux='init_tmux'

# --- Interactive jobs -----------------------------------------------------
# si [hours] [cpus] [mem] - interactive shell on a compute node.
si() {
	salloc --time="${1:-1}:00:00" --cpus-per-task="${2:-4}" --mem="${3:-16G}"
}

# sgpu [hours] [cpus] [mem] - same, with one GPU.
sgpu() {
	salloc --gpus-per-node=1 --time="${1:-1}:00:00" \
		--cpus-per-task="${2:-8}" --mem="${3:-32G}"
}

# --- Modules and environments ---------------------------------------------
# R with the standard environment. $R_MODULE comes from ~/.config/hpc/modules
# (e.g. R_MODULE=r/4.6.1); bare `r` loads the cluster's default. Pass a module
# spec to override once: `loadr r/4.4.0`.
loadr() { module load "$STDENV" "${1:-$R_MODULE}"; }

# Python + a virtualenv. With no argument, builds a throwaway env in
# $SLURM_TMPDIR (node-local, gone when the job ends); with a name, uses
# ~/venvs/<name> and creates it on first use.
loadpy() {
	module load "$STDENV" "$PY_MODULE"
	if [ -z "${1:-}" ]; then
		# Per-user path: /tmp is shared on login nodes, and activating
		# someone else's stale venv is worse than building a new one.
		_venv="${SLURM_TMPDIR:-/tmp}/venv-$USER"
	else
		_venv="$HOME/venvs/$1"
	fi
	[ -d "$_venv" ] || virtualenv --no-download "$_venv"
	# shellcheck disable=SC1091
	. "$_venv/bin/activate"
	unset _venv
}

# --- Job scripts ----------------------------------------------------------
# newjob <template> [dest] - copy a template into the current directory.
# With no arguments, lists what is available.
newjob() {
	_tpl_dir="${XDG_DATA_HOME:-$HOME/.local/share}/hpc/templates"
	if [ -z "${1:-}" ]; then
		echo "templates: $(ls "$_tpl_dir" | tr '\n' ' ')"
		unset _tpl_dir
		return 0
	fi
	cp -i "$_tpl_dir/$1" "${2:-./$1}" && echo "wrote ${2:-./$1}"
	unset _tpl_dir
}

# jobout <jobid> - follow a running job's output. Looks in ./logs too, since
# that is where the templates write.
jobout() {
	_log="$(ls -t ./*"$1"*.out ./logs/*"$1"*.out 2>/dev/null | head -1)"
	if [ -z "$_log" ]; then
		echo "no .out file matching '$1' here or in ./logs" >&2
		unset _log
		return 1
	fi
	echo "$_log"
	tail -f "$_log"
	unset _log
}
