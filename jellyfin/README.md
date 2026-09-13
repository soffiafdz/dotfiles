# jellyfin

A runit service that runs Jellyfin as a rootless podman container on janus.
Its target is the root filesystem, not the home directory:

    sudo stow -d ~/Repos/dotfiles -t / jellyfin
    sudo ln -s /etc/runit/sv/jellyfin /run/runit/service/

Stowing it with the usual `-t ~` only creates a useless `~/etc`.

What this restores: the container launch (image, ports, volume mounts).
What it does not restore: the Jellyfin state itself, meaning the library
database, metadata and user accounts, which live in
`~/.local/share/jellyfin/config` and must be backed up separately.
`~/.local/share/jellyfin/cache` can be discarded.

`run` hardcodes the user, UID 1000 and the media paths under `/mnt/vault`;
adjust them if the machine layout changes.
