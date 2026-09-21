# Containers

One pipeline, three machines. Images are built on janus (native amd64, NVIDIA
GPU), pushed to a registry, and converted to Apptainer on the clusters, which
run nothing else. Hestia only drives janus or runs the occasional local
container; it is Apple Silicon, so anything it builds for the cluster would be
emulated.

Podman rather than Docker on the Linux boxes: it is already there rootless for
Jellyfin on janus, needs no daemon and no runit service, and keeps the user out
of the root-equivalent `docker` group. The Dockerfiles, the registry and the
`.sif` conversion are identical either way; Docker remains the documented
fallback if GPU passthrough through podman turns out awkward.

Nothing below has been run on the machines yet; the GPU step is the one to
verify first.

## janus (Artix, build host)

    sudo pacman -S podman-docker buildah nvidia-container-toolkit
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml

`podman-docker` provides a `docker` shim so the usual commands keep working.
Rootless podman is already configured (subuid/subgid, storage) because the
Jellyfin service uses it. If `nvidia-container-toolkit` is missing from the
Artix repos, it is in the AUR.

The CDI spec must be regenerated after every NVIDIA driver update; a GPU that
"worked last month" is nearly always this.

Verify, in order:

    podman run --rm quay.io/podman/hello
    podman run --rm --device nvidia.com/gpu=all \
        docker.io/nvidia/cuda:12.4.0-base-ubuntu22.04 nvidia-smi
    podman build --platform linux/amd64 -t hippseg:dev .

GPU flag: rootless podman uses CDI, `--device nvidia.com/gpu=all`. Docker's
`--gpus all` does **not** work through the shim, so translate it in any
upstream `docker run` line (AssemblyNet's GPU instructions, for one). The CPU
instructions translate verbatim.

Registry, once:

    podman login ghcr.io          # GitHub PAT with write:packages

## tango (Artix laptop)

Nothing, until offline iteration in the office is actually wanted. Then the
same as janus minus the NVIDIA parts:

    sudo pacman -S podman-docker buildah

Otherwise tango builds on janus over ssh like hestia does.

## hestia (macOS, Apple Silicon)

    brew install podman           # in the Brewfiles
    podman machine init --cpus 4 --memory 8192 --disk-size 60 --now

That is a local Linux VM for running containers; amd64 images run and build
emulated, which is fine for a quick look and wrong for a real build. No Docker
Desktop, no Colima.

Anything destined for the cluster is built on janus over ssh:

    ssh janus 'cd ~/src/hippseg &&
        podman build --platform linux/amd64 -t ghcr.io/soffiafdz/hippseg:0.3 . &&
        podman push ghcr.io/soffiafdz/hippseg:0.3'

janus is a home host, so it lives in `~/.ssh/config.local`, with key login
that does not prompt.

## rorqual, trillium

    module load apptainer
    apptainer build ~/projects/def-<pi>/$USER/sif/hippseg-0.3.sif \
        docker://ghcr.io/soffiafdz/hippseg:0.3

Login nodes only: compute nodes have no network. `.sif` files are large and
go in `~/projects`, not `$HOME`. One tag per analysis; a rerun should use the
same file.

In a job:

    apptainer exec --nv --cleanenv \
        -B "$SLURM_TMPDIR:/work" -B "$SCRATCH/study:/data:ro" \
        ~/projects/def-<pi>/$USER/sif/hippseg-0.3.sif \
        hippseg --in /data/sub-01 --out /work/sub-01

`--nv` needs a GPU allocation. Without a registry, `podman save` on janus,
copy the tarball, and `apptainer build x.sif docker-archive://x.tar`.

## Image hygiene, for the segmentation tool

Apptainer runs the container as the calling user with the image read-only, so
images that assume root at runtime or write inside themselves break on the
cluster. Pin base image digests, keep build tools out of the final layer, run
as a non-root UID, and write only to bind-mounted paths. AssemblyNet is
distributed as a Docker image and needs none of this; it converts as-is.
