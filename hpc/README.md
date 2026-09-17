# hpc

Cluster-only helpers for the Digital Research Alliance of Canada (Rorqual,
Trillium). Stowed by `./bootstrap -f hpc`, always with `--no-folding`: the
account file below is machine-local and must not land in the repo.

    ~/.config/hpc/env.sh              Slurm aliases and functions
    ~/.config/hpc/account             your allocation, e.g. def-pi (untracked)
    ~/.local/bin/hpc-setup            one-time install on a login node
                                      (zsh prompt, bash handoff, account)
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
| `loadr [version]` | `StdEnv/2023` + the R module |
| `loadpy [name]` | python module + a virtualenv (node-local, or `~/venvs/<name>`) |
| `newjob [template]` | copy an sbatch template here; no argument lists them |
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

## Editing

vim, not nvim. `~/.vimrc` detects `$CC_CLUSTER` and loads no plugins: built-in
statusline, `:find` with `path+=**` for `<leader>ff`, and `<leader>r` mappings
that send code to R running in another tmux pane (`<leader>rr` opens one,
`rl` line, `r` visual selection, `rf` sources the file). Set `g:tmux_target`
if the pane is not the next one in the window.

## Not here

No nvim: a plugin tree of tens of thousands of files is a poor trade against
the `$HOME` file quota for an editor used to fix job scripts and read logs.
Write code on your workstation, run it here.

No conda or micromamba: `.zshrc` returns early when `$CC_CLUSTER` is set, so
the mamba block never runs. Use modules plus a virtualenv, or put a conda
environment inside an Apptainer container.
