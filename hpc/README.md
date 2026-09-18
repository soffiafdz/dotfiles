# hpc

Cluster-only helpers for the Digital Research Alliance of Canada (Rorqual,
Trillium). Stowed by `./bootstrap -f hpc`, always with `--no-folding`: the
account file below is machine-local and must not land in the repo.

    ~/.config/hpc/env.sh              Slurm aliases and functions
    ~/.config/hpc/account             your allocation, e.g. def-pi (untracked)
    ~/.config/hpc/modules             module versions for this cluster (untracked)
    ~/.local/bin/hpc-setup            one-time install on a login node
                                      (zsh prompt, bash handoff, account)
    ~/.local/bin/init_tmux            start or attach the cluster's session
    ~/.local/share/hpc/templates/     sbatch templates

The clusters' login shell is bash and `chsh` does not work there, so
`hpc-setup` writes `~/.bashrc.d/10-zsh.sh` (machine-local, not in this repo):
the stock `~/.bashrc` sources that directory, and it `exec`s zsh for
interactive shells only, leaving scp, rsync, `ssh host cmd` and job scripts on
plain bash. zsh then reads `~/.zshenv` from the `zsh` package, which sets
`ZDOTDIR` and pulls in the rest.

`shell/profile.d/hpc.sh` sources `env.sh` when `$CC_CLUSTER` is set, and exports
`SBATCH_ACCOUNT` / `SALLOC_ACCOUNT` / `SRUN_ACCOUNT` from the account file, so
no job script or `salloc` call needs `--account`.

## What you get

| | |
|---|---|
| `sq`, `sqs`, `sqa` | your queue, estimated start times, per-array-task view |
| `sj`, `sme`, `quota` | accounting, fair-share, disk and file-count usage |
| `si [h] [cpus] [mem]` | interactive shell on a compute node (default 1h/4/16G) |
| `sgpu [h] [cpus] [mem]` | same with one GPU |
| `loadr [module]` | `$STDENV` + `$R_MODULE` |
| `loadpy [name]` | `$PY_MODULE` + a virtualenv (node-local, or `~/venvs/<name>`) |
| `newjob [template]` | copy an sbatch template here; no argument lists them |
| `init_tmux` (`_tmux`) | start or attach a session named after the cluster; `-m` opens a grouped view |
| `jobout <jobid>` | follow a running job's output |

## Rules the templates follow

- Resources: ask for what a task really needs. Jobs of 3 hours or less are
  eligible for more nodes and start sooner; `seff <jobid>` after the fact
  shows what was actually used.
- Where things live: the repo and your config in `$HOME` (private, backed up);
  data in `~/projects` (group-shared) or `~/scratch` (purged, not backed up).
- I/O: work in `$SLURM_TMPDIR` (node-local, wiped at the end) and rsync results
  back to `~/scratch` or `~/projects`. The shared filesystems are slow with
  many small files, and the file-count quota is the one that bites.
- Network: compute nodes have none. `pip install --no-index` uses the
  Alliance's own wheels; anything else must be fetched on a login node.
- `--cpus-per-task` is threads, `--ntasks` is MPI ranks. Mixing them up is the
  classic SGE-to-Slurm mistake.

## tmux and login nodes

A tmux server is per host, and `rorqual.alliancecan.ca` round-robins across
login nodes: a session started on rorqual3 is invisible from rorqual2, where a
plain `tmux new -As` would quietly start a second, empty one with the same
name. `init_tmux` records the node in
`~/.local/state/hpc/tmux-<session>.node` and, when you land elsewhere, prints
the `ssh <node> -t init_tmux <session>` line rather than starting a duplicate.

`-m` works from inside tmux, which is where you would actually reach for it:
`tmux attach` and `new-session -t` refuse to nest, so the session is created
detached and entered with `switch-client`. Running it a second time enters the
existing monitor session rather than failing on a duplicate name. Close it with
`tmux kill-session -t <session>-monitor`; the windows belong to the group, so
the main session is untouched.

Unlike the BIC helper of the same name, there is no conda to load: tmux is
installed on the clusters.

## Module versions

Clusters differ and versions move, so they are machine-local, like the
account. Write `~/.config/hpc/modules`:

    R_MODULE=r/4.6.1
    PY_MODULE=python/3.13
    STDENV=StdEnv/2023

`shell/profile.d/hpc.sh` exports these; `loadr`, `loadpy` and vim's R pane all
read them. Unset, they fall back to `r`, `python` and `StdEnv/2023`, which load
each module's default. `module spider r` lists what a cluster has, and says
which `StdEnv` a given version needs. Job scripts pin their versions inline
instead: a job should not change behaviour because a default moved.

## Editing

vim, not nvim, and the same `~/.vimrc` as everywhere else: plugin-free, ported
from the nvim config. Space is the leader and `\` the localleader, as in
LazyVim.

R works through tmux, mirroring R.nvim's mappings so the muscle memory
carries: `<localleader>rf` opens R in a `tmux split-window -hf`,
`<localleader>l` sends the line, `<localleader>ss` the visual selection,
`<localleader>aa` sources the file, `<localleader>rq` quits.

The pane loads the R module itself — a tmux pane starts from the tmux server's
environment, so modules loaded in the current shell are not there. It then runs
`radian` if it is on `$PATH`, otherwise plain `R`. `:Rcmd` shows the exact
command. Override the module with `g:r_module` in `~/.vimrc.local` (untracked)
when the cluster's R version differs from the default, and `g:r_tmux_target`
if the pane is not the next one.

radian is not installed on the clusters. Plain R works out of the box; to get
radian, build it on a **login node** into a virtualenv that is on your `$PATH`
(`avail_wheels radian rchitect` first — `rchitect` embeds R and may have to
come from PyPI rather than the Alliance wheelhouse).

Plugin stand-ins: built-in statusline, `:find` over `path+=**` (`<leader>ff`),
`gcc`/`gc` comment toggle from `commentstring`, `<leader>u*` toggles.

## Not here

No nvim, and no vim plugins: a plugin tree of tens of thousands of files is a
poor trade against the `$HOME` file quota for an editor used to fix job
scripts and read logs. Write code on your workstation, run it here.

No conda or micromamba: `.zshrc` returns early when `$CC_CLUSTER` is set, so
the mamba block never runs. Use modules plus a virtualenv, or put a conda
environment inside an Apptainer container.
