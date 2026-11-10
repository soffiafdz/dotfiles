# Keys, 2FA and recovery

How the GPG key, its offline backup and the hardware keys fit together, and
what to do when one of them is lost. This file is public: it holds procedures
only. Secrets and specifics live elsewhere:

| What | Where |
|---|---|
| The GPG passphrase and the backup stick's passphrase | on paper, offline |
| Where the paper and the stick are kept | nowhere digital: memory, and one trusted person |
| Hardware key names and serials | `pass dev/yubikeys` |
| Which keys a service has | that service's pass entry, `2fa:` line |
| Procedures | here |

The layering is deliberate: paper plus this file recover the GPG key, and the
GPG key opens pass. Nothing depends on what it is supposed to recover, which
is why the physical locations are not in pass: when they are needed, pass is
exactly what cannot be opened.

## GPG key

One key, fingerprint `3078F339B6C8EFE014668B7A034BE9474D7884B3`. It encrypts
the whole password store, so it is the single point of failure.

Every host that uses pass holds its own copy, and **each copy has its own
passphrase**: `gpg --passwd` changes only the local one. After changing it,
change it on the other hosts too and re-export to the backup stick in the
same sitting, or the copies drift apart.

## Offline backup: `kryptos`

A USB stick, LUKS2 with the label `kryptos`, ext4 inside. Only readable from
Linux; the printed paperkey covers the case where no Linux machine is left.

| File | What it is |
|---|---|
| `secret-keys.asc` | Full secret key. The normal restore path. |
| `secret-subkeys.asc` | Subkeys only: decrypts and signs, cannot certify. |
| `public.asc`, `public.gpg` | Public key. Needed for a paperkey restore. |
| `ownertrust.txt` | Trust settings. |
| `paperkey.txt`, `paperkey.bin`, `paperkey-qr.png` | Secret key reduced to its secret parts, as text, raw bytes and a QR image, for printing. |
| `revoke.asc` | Revocation certificate. |

Find it, open it, close it. Always close before unplugging:

    lsblk -o NAME,FSTYPE,LABEL | grep kryptos      # the crypto_LUKS partition
    sudo cryptsetup open /dev/sdX1 kryptos
    sudo mount /dev/mapper/kryptos /mnt/kryptos
    ...
    sudo umount /mnt/kryptos
    sudo cryptsetup close kryptos

Check the passphrase without unlocking anything. LUKS has no lockout, so wrong
guesses are harmless:

    sudo cryptsetup open --test-passphrase /dev/sdX1

### Restore test

Once a year, and after every GPG passphrase change. Imports into a throwaway
keyring in RAM; the real one is not touched.

    T=$(mktemp -d /dev/shm/gpgtest.XXXX); chmod 700 "$T"
    gpg --homedir "$T" --import /mnt/kryptos/secret-keys.asc
    echo test | gpg --homedir "$T" -u 3078F339B6C8EFE014668B7A034BE9474D7884B3 --sign >/dev/null && echo "BACKUP OK"
    rm -rf "$T"

If it only accepts an old passphrase, re-export (below).

### Restoring for real

    gpg --import /mnt/kryptos/secret-keys.asc
    gpg --import-ownertrust /mnt/kryptos/ownertrust.txt

From paper instead: scan or type the paperkey back into a file, then

    paperkey --pubring /mnt/kryptos/public.gpg --secrets paperkey.txt | gpg --import

(`--input-type raw` for the `.bin` form.) Without the stick, the public key
has to come from another host or a keyserver first.

If the key is compromised rather than lost: `gpg --import revoke.asc`, then
publish the revoked key wherever the public key was published.

### Re-exporting

    gpg --armor --export-secret-keys    3078F339B6C8EFE014668B7A034BE9474D7884B3 > /mnt/kryptos/secret-keys.asc
    gpg --armor --export-secret-subkeys 3078F339B6C8EFE014668B7A034BE9474D7884B3 > /mnt/kryptos/secret-subkeys.asc
    gpg --armor --export                3078F339B6C8EFE014668B7A034BE9474D7884B3 > /mnt/kryptos/public.asc
    gpg --export                        3078F339B6C8EFE014668B7A034BE9474D7884B3 > /mnt/kryptos/public.gpg
    gpg --export-ownertrust > /mnt/kryptos/ownertrust.txt
    gpg --export-secret-keys 3078F339B6C8EFE014668B7A034BE9474D7884B3 | paperkey --output /mnt/kryptos/paperkey.txt

A new stick: `cryptsetup luksFormat --label kryptos <part>`, open it, then
`mkfs.ext4 -L kryptos /dev/mapper/kryptos`, mount, export.

## Hardware keys

Two YubiKey 5C NFC: one carried, one stored apart from it.

**Every service registers each key separately**, so losing one means revoking
one registration per service and nothing else. The one exception is a service
that allows only a single authenticator app: the same secret goes on
both keys, and losing one means re-enrolling the other. Name the key at
registration wherever the service allows it.

To list where a key is registered: `pass grep -i <key name>`.

| Protocol | Used for | Notes |
|---|---|---|
| FIDO2 / passkey | Most web services | Behind the key's PIN. Prefer "passkey" over "security key" where both are offered. |
| Yubico OTP, slot 2 | The Alliance (CCDB) | Long touch, 3-5 s. Slot 1 keeps the factory Yubico credential. The public ID is derived from the key's serial. |
| OATH-TOTP | Services offering "authenticator app" only, and Microsoft Entra where the tenant disables FIDO2 | Up to 32 per key. Not behind the PIN. |

Tooling. On Linux the smart-card daemon is needed for OATH:

    sudo pacman -S yubikey-manager ccid pcsclite-runit
    sudo ln -s /etc/runit/sv/pcscd /run/runit/service/

On macOS, `brew install ykman` or Yubico Authenticator. `ykman` refuses to pick
between two keys, so plug in one at a time.

### Setting up a key

    ykman info                                   # note the serial in the inventory
    ykman fido access change-pin                 # same PIN on both keys, stored in pass
    ykman otp yubiotp 2 -S -g -G -O /dev/shm/otp.txt
                                                 # register the three values, then shred -u
    ykman oath accounts add -i "<Issuer>" "<account>"
                                                 # secret at the prompt, never on the command line
    ykman oath accounts code -s <match>          # enter it before leaving the service's page

The FIDO2 PIN is the one thing here that locks: eight wrong attempts disable
FIDO2 on that key, and the reset deletes every FIDO2 credential on it.

Recovery codes go in that service's pass entry under `recovery:`, one per line
so used ones can be deleted.

### When a key is lost

Revoke first, then enrol the replacement.

1. Registrations that work **without the PIN**, first: Yubico OTP (one touch
   produces a code) and OATH (anyone with `ykman` can read the codes).
2. Then FIDO2, which needs the PIN.
3. **Apple is the exception**: it requires at least two keys, so add the
   replacement before removing the lost one.
4. Entra lists TOTP registrations anonymously. The service's pass entry
   records which was added for which key; if that is unknown, delete both and
   enrol both keys again in a known order.
5. Set up the replacement as above, then update `dev/yubikeys` and the `2fa:`
   lines in pass.

## Password store conventions

Lowercase entries in category folders (`dev/`, `finance/`, `work/`, ...).
Password on line 1, then `key: value` lines:

    <password>
    login: ...
    url: ...
    2fa: fido2 (both keys) | totp (two registrations) | sms | none
    recovery:
      <code>
      <code>

One entry is not a credential and must not be moved or deleted: see
`docs/software-setup.md`, "Password Store Notes".
