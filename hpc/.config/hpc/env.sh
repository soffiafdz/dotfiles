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
alias scq='scancel -u "$USER"'                 # cancel everything (asks first)
alias sj='sacct -X -o JobID,JobName%24,State,Elapsed,ReqMem,MaxRSS,CPUTime'
alias sme='sshare -U -u "$USER"'               # fair-share / priority

# Disk and file-count quotas: the file count bites before the space does.
alias quota='diskusage_report'

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
# R with the standard environment; pass a version to override.
loadr() { module load StdEnv/2023 "r/${1:-4.4.0}"; }

# Python + a virtualenv. With no argument, builds a throwaway env in
# $SLURM_TMPDIR (node-local, gone when the job ends); with a name, uses
# ~/venvs/<name> and creates it on first use.
loadpy() {
	module load StdEnv/2023 "python/${PYVER:-3.11}"
	if [ -z "${1:-}" ]; then
		_venv="${SLURM_TMPDIR:-/tmp}/venv"
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

# jobout <jobid> - follow a running job's output.
jobout() { tail -f "$(ls -t ./*"$1"*.out 2>/dev/null | head -1)"; }
