# restic

Backups for janus: a restic repository on the dedicated `/mnt/arca` disk,
served by `rest-server` to other machines over Tailscale.

- `rest-server` runs as the `restic` system user, **append-only**, listening
  only on janus's Tailscale address. Clients can add snapshots but never
  delete them.
- `restic-backup` (root, nightly at 03:00) dumps the digiKam MariaDB
  databases, then backs up `/home`, `/mnt/cella` and `/etc` through the
  rest-server. Exclusions live in `etc/restic/excludes`.
- `restic-prune` (Sundays 05:30) applies retention (7 daily, 4 weekly,
  12 monthly, 3 yearly) and checks a sample of the data. It works on the
  repository path directly, because append-only clients cannot prune.
- A weekly `fstrim -av` rides along in the same cron file.

Logs: `/var/log/restic/` and `/var/log/rest-server/`.

## Install

    yay -S --needed restic rest-server-bin cronie cronie-runit
    sudo ~/Repos/dotfiles/restic/install.sh

Files are copied into place, not stowed: cronie ignores symlinked `cron.d`
entries and runit creates `supervise/` next to the run script.

## Repository password

`install.sh` generates it once into `/etc/restic/arca.pass` (root and the
`restic` group only). `/etc/restic` is excluded from the backup. Keep a copy
in `pass` and on paper: without it the repository cannot be read.

## Restore

    sudo restic -r "rest:http://$(tailscale ip -4):8000/" \
      --password-file /etc/restic/arca.pass \
      restore latest --target /tmp/restore --include /mnt/cella/Pictures/some/album

Go through rest-server rather than the path, so root never writes files into
the repository that the `restic` user then can't touch.
