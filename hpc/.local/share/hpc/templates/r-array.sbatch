#!/bin/bash
# One array task per subject. Edit the resources, then:
#     mkdir -p logs && sbatch r-array.sbatch
#
# --array should match the number of lines in subjects.txt; %20 caps how many
# run at once. Ask for the time and memory one task really needs: short jobs
# (<=3h) are eligible for more nodes and start sooner. Check afterwards with
#     seff <jobid>_<taskid>
#SBATCH --job-name=r-array
#SBATCH --array=1-100%20
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --output=logs/%x-%A_%a.out
#SBATCH --error=logs/%x-%A_%a.err
#SBATCH --mail-type=END,FAIL
# --account comes from $SBATCH_ACCOUNT (see ~/.config/hpc/account)

set -euo pipefail

module load StdEnv/2023 r/4.4.0

SUBJECT=$(sed -n "${SLURM_ARRAY_TASK_ID}p" subjects.txt)
[ -n "$SUBJECT" ] || { echo "no subject on line ${SLURM_ARRAY_TASK_ID}" >&2; exit 1; }

echo "task ${SLURM_ARRAY_TASK_ID}: $SUBJECT on $(hostname) at $(date)"

# Work on node-local disk: the shared filesystems are slow for many small
# files, and $SLURM_TMPDIR is wiped when the task ends.
IN="$SCRATCH/study/data/$SUBJECT"
OUT="$SLURM_TMPDIR/$SUBJECT"
FINAL="$SCRATCH/study/derivatives/$SUBJECT"
mkdir -p "$OUT" "$FINAL"

Rscript --vanilla analysis.R "$SUBJECT" "$IN" "$OUT"

# Copy results back before the task exits.
rsync -a "$OUT/" "$FINAL/"
echo "task ${SLURM_ARRAY_TASK_ID}: done at $(date)"
