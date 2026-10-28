# nvidia

A boot script that regenerates the NVIDIA CDI spec on janus, so rootless
podman can hand the GPU to containers. Its target is the root filesystem:

    sudo stow -d ~/Repos/dotfiles -t / nvidia

runit runs every executable `/etc/local.d/*.start` in stage 2, before
services. The spec goes to `/var/run/cdi/nvidia.yaml`, the toolkit's default
location; `/run` is wiped at shutdown, so a stale spec cannot outlive a driver
update.

To regenerate without rebooting, run the script directly:

    sudo /etc/local.d/nvidia-cdi.start
