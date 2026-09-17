#!/bin/bash
# Single-GPU job. Rorqual's GPU nodes carry NVIDIA H100s; check the wiki for
# the current --gpus-per-node syntax and whether a whole node is required.
#SBATCH --job-name=gpu
#SBATCH --gpus-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=03:00:00
#SBATCH --output=logs/%x-%j.out
#SBATCH --mail-type=END,FAIL

set -euo pipefail

module load StdEnv/2023 python/3.11 cuda
nvidia-smi

# Build the environment on node-local disk from pre-built wheels. Compute
# nodes have no internet: --no-index is required, not just polite.
virtualenv --no-download "$SLURM_TMPDIR/env"
source "$SLURM_TMPDIR/env/bin/activate"
pip install --no-index --upgrade pip
pip install --no-index -r requirements.txt

python train.py --data "$SCRATCH/study/data" --out "$SLURM_TMPDIR/out"
rsync -a "$SLURM_TMPDIR/out/" "$SCRATCH/study/runs/$SLURM_JOB_ID/"
