# Dual-Boot Installation: Artix Linux + Windows (AtlasOS)

## Overview

Install order: **Windows first → AtlasOS → Artix Linux**

Windows overwrites the bootloader and doesn't detect Linux.
Linux (GRUB + os-prober) detects Windows automatically.
AtlasOS doesn't touch the EFI partition, so GRUB chainloads fine.

## Partition Layout (GPT / UEFI)

| # | Partition | Size | FS | Notes |
|---|-----------|------|----|-------|
| 1 | EFI (ESP) | 1 GB | FAT32 | Shared. Pre-create before Windows |
| 2 | MSR | 128 MB | — | Auto-created by Windows |
| 3 | Recovery | ~500 MB | NTFS | Auto-created by Windows |
| 4 | Windows (C:) | 100–200 GB | NTFS | Gaming + Steam |
| 5 | Linux root (/) | 60–80 GB | ext4 | System + packages |
| 6 | Swap | 8 GB | swap | Match RAM if hibernation wanted |
| 7 | Linux home (/home) | 100+ GB | ext4 | User data |
| 8 | Shared data | Remaining | NTFS | Accessible from both OSes |

**Why pre-create the ESP:** Windows defaults to 100 MB which is too
small once GRUB and Linux kernels are added. Pre-creating 1 GB avoids
problems later.

## Step 1: Prepare the Disk

Boot any live Linux USB (Artix ISO works):

```bash
gdisk /dev/sdX    # or /dev/nvmeXn1

# Create partitions:
# n → 1 → default → +1G → EF00 (EFI System)
# Leave remaining space for Windows installer
# w → confirm
```

Format the ESP:

```bash
mkfs.fat -F32 /dev/sdX1
```

## Step 2: Install Windows 11

1. Boot Windows 11 installer USB
2. Choose custom install
3. Select the unallocated space AFTER the ESP
4. Windows will reuse the existing ESP and create MSR/Recovery/OS
5. Complete Windows setup (use local account if possible)

## Step 3: Windows Pre-AtlasOS Configuration

### Disable Fast Startup (MANDATORY)

Control Panel → Power Options → Choose what power buttons do →
Change settings currently unavailable → Uncheck "Turn on fast startup"

Also from admin Command Prompt:

```cmd
powercfg /H off
```

### Disable BitLocker / Device Encryption

Settings → Privacy & Security → Device Encryption → Off

BitLocker + dual-boot = pain. Disabling Secure Boot (needed for
Artix) triggers BitLocker recovery. Don't use it.

### Set Hardware Clock to UTC

From admin Command Prompt:

```cmd
reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f
```

Prevents clock skew when switching between OSes.

### Fully Update Windows

Settings → Windows Update → Check repeatedly until zero updates.
Also update Microsoft Store apps.

## Step 4: Apply AtlasOS

**Requirements:** Windows 11 Pro (Home not supported). Clean install.

1. Download AME Wizard + Atlas Playbook (.apbx) from atlasos.net
2. Disable Windows Security:
   - Virus & threat protection → Manage settings
   - Turn off all four toggles (Real-time, Cloud, Sample, Tamper)
3. Run AME Wizard, update it if prompted
4. Drag Atlas Playbook into AME Wizard
5. Configure options:
   - CPU mitigations: leave enabled
   - Windows Updates: your choice (manual recommended)
   - Edge: uninstall
   - Defender: keep (can toggle later via script)
6. Execute — system will restart multiple times
7. Don't interrupt the process

Post-install: Atlas folder on desktop has config scripts.

## Step 5: Shrink Windows Partition

If you didn't pre-allocate Linux space:

Windows Disk Management → Right-click C: → Shrink Volume →
Free up space for Linux partitions.

## Step 6: Disable Secure Boot

Enter UEFI firmware (Del or F2 at POST):

1. Find Secure Boot setting (usually under Security or Boot)
2. Disable it
3. Save and exit

Artix ISO is not Secure Boot signed.

## Step 7: Install Artix Linux (runit)

### Boot and Partition

```bash
# Verify UEFI mode
ls /sys/firmware/efi/efivars

# Partition free space with cfdisk/fdisk
# Do NOT touch Windows partitions (1-4)
cfdisk /dev/sdX
# Create: root (Linux filesystem), swap, home, shared (NTFS)

# Format
mkfs.ext4 /dev/sdX5       # root
mkswap /dev/sdX6           # swap
mkfs.ext4 /dev/sdX7        # home
mkfs.ntfs -f /dev/sdX8     # shared data
```

### Mount and Install

```bash
mount /dev/sdX5 /mnt
mkdir -p /mnt/boot/efi /mnt/home
mount /dev/sdX1 /mnt/boot/efi   # existing ESP
mount /dev/sdX7 /mnt/home
swapon /dev/sdX6

# Install base system
basestrap /mnt base base-devel runit elogind-runit linux linux-firmware

# Generate fstab
fstabgen -U /mnt >> /mnt/etc/fstab
```

### Configure (chroot)

```bash
artix-chroot /mnt

# Timezone
ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc --utc

# Locale
# Uncomment your locale in /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "yourhostname" > /etc/hostname

# Root password
passwd

# Create user
useradd -m -G wheel -s /bin/zsh yourusername
passwd yourusername
# Uncomment %wheel ALL=(ALL:ALL) ALL in visudo

# Essential packages
pacman -S grub os-prober efibootmgr ntfs-3g \
  networkmanager networkmanager-runit \
  git neovim zsh kitty
```

### Install GRUB

```bash
grub-install --target=x86_64-efi \
  --efi-directory=/boot/efi \
  --bootloader-id=Artix

# CRITICAL: enable os-prober for dual-boot
# Edit /etc/default/grub:
#   GRUB_DISABLE_OS_PROBER=false

grub-mkconfig -o /boot/grub/grub.cfg
```

Expected output should include:

```
Found Windows Boot Manager on /dev/sdX1@/EFI/Microsoft/Boot/bootmgfw.efi
```

### Enable Services (runit)

```bash
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default/
```

### Reboot

```bash
exit         # leave chroot
umount -R /mnt
reboot
```

GRUB should show both Artix and Windows Boot Manager.

## Step 8: Post-Install (Artix)

### Mount Shared Data Partition

Add to `/etc/fstab`:

```
UUID=XXXX  /mnt/data  ntfs-3g  defaults,nofail,windows_names  0 0
```

Get UUID with `blkid /dev/sdX8`.

### Enable Arch Repositories

```bash
pacman -S artix-archlinux-support
# Add [extra] repo to /etc/pacman.conf
pacman -Sy
```

### Install AUR Helper

```bash
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### Stow Dotfiles

```bash
cd ~/Developer/dotfiles && stow -t ~ <package>
# Repeat for: zsh, nvim, kitty, git, tmux, etc.
```

### Compile dwm

```bash
cd ~/Developer/dwm && sudo make clean install
```

## Troubleshooting

### GRUB Doesn't Show Windows

```bash
# Verify os-prober finds it
os-prober
# Should output: /dev/sdX1@/EFI/Microsoft/Boot/bootmgfw.efi:...

# Check requirements
pacman -Q os-prober ntfs-3g fuse3

# Check /etc/default/grub has:
#   GRUB_DISABLE_OS_PROBER=false

# Regenerate
grub-mkconfig -o /boot/grub/grub.cfg
```

If os-prober still fails, add manual entry in `/etc/grub.d/40_custom`:

```
menuentry "Windows Boot Manager" {
    insmod part_gpt
    insmod fat
    search --no-floppy --fs-uuid --set=root XXXX-XXXX
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

Replace `XXXX-XXXX` with ESP UUID from `blkid`.

### Windows Time Is Wrong After Booting Linux

The `RealTimeIsUniversal` registry key from Step 3 should fix this.
If not applied yet, run the reg command from Windows admin prompt.

### NTFS Partition Won't Mount Read-Write

Usually means Windows wasn't fully shut down (Fast Startup).
Boot Windows, ensure Fast Startup is off, do a full shutdown
(hold Shift while clicking Shut Down), then boot Linux.

### AtlasOS Re-enables Fast Startup

Check after applying AtlasOS — Windows Updates and playbook
changes can silently re-enable it. Disable again if so.

### Boot Goes Straight to Windows (Skips GRUB)

UEFI boot order was changed. Enter firmware setup and set
Artix/GRUB as first boot entry, or use:

```bash
efibootmgr -o XXXX,YYYY  # Artix first, then Windows
```
