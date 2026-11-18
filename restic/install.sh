#!/bin/sh
# Install the restic/rest-server setup on janus. Run with sudo after
# installing the packages (see README.md). Safe to re-run.
set -eu
[ "$(id -u)" = 0 ] || { echo "run with sudo"; exit 1; }
src=$(cd "$(dirname "$0")" && pwd)

mountpoint -q /mnt/arca || { echo "/mnt/arca is not mounted"; exit 1; }

# Service user that owns the repository files.
id restic >/dev/null 2>&1 ||
  useradd --system --no-create-home --home-dir /mnt/arca/restic \
    --shell /usr/bin/nologin restic

install -dm 700 -o restic -g restic /mnt/arca/restic /var/cache/restic
install -dm 755 /var/log/restic /etc/restic

# Config and scripts are copied, not symlinked: cronie refuses symlinked
# cron.d files and runit writes supervise/ next to the run script.
install -m 644 "$src/etc/restic/excludes" /etc/restic/excludes
install -m 644 "$src/etc/cron.d/restic" /etc/cron.d/restic
install -m 755 "$src/usr/local/sbin/restic-backup" /usr/local/sbin/
install -m 755 "$src/usr/local/sbin/restic-prune" /usr/local/sbin/
install -dm 755 /etc/runit/sv/rest-server/log
install -m 755 "$src/etc/runit/sv/rest-server/run" /etc/runit/sv/rest-server/run
install -m 755 "$src/etc/runit/sv/rest-server/log/run" /etc/runit/sv/rest-server/log/run

# Repository password: generated once, readable by root and the restic user.
pw=/etc/restic/arca.pass
if [ ! -s "$pw" ]; then
  (umask 077; LC_ALL=C tr -dc 'a-km-z2-9' </dev/urandom | head -c 40 > "$pw")
  echo "new repository password written to $pw"
fi
chown root:restic "$pw"; chmod 640 "$pw"

# Create the repository if it doesn't exist yet.
[ -f /mnt/arca/restic/config ] ||
  chpst -u restic:restic env RESTIC_CACHE_DIR=/var/cache/restic \
    restic init -r /mnt/arca/restic --password-file "$pw"

# Enable services (runit picks them up within a few seconds).
for sv in cronie rest-server; do
  [ -d /etc/runit/sv/$sv ] || { echo "missing /etc/runit/sv/$sv"; exit 1; }
  [ -e /run/runit/service/$sv ] || ln -s /etc/runit/sv/$sv /run/runit/service/
done

echo "done. next: save the password in pass, then start the first backup."
