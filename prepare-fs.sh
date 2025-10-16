#!/usr/bin/env bash

if [[ -z "${NVME_DEVICE}" ]]; then
  echo "NVME_DEVICE must be set!"
  exit 1
fi

if [[ -z "${SWAP_SIZE_GIB}" ]]; then
  echo "SWAP_SIZE_GIB must be set!"
  exit 1
fi

echo -n "THIS WILL WIPE EVERYTHING ON ${NVME_DEVICE}! TYPE 'OKAY' IN ALL CAPS TO CONTINUE: "
read OKAY
echo ""

if [ "$OKAY" != "OKAY" ]; then
  echo "Did not receive an 'OKAY'. Aborting."
  exit 1
else
  for mnt1 in `mount | grep /dev/mapper/root | awk '{print $3}'`; do
    for mnt2 in `mount | grep /dev/mapper/root | awk '{print $3}'`; do
      umount $mnt2
    done
  done

  for mnt1 in `mount | grep ${NVME_DEVICE} | awk '{print $3}'`; do
    for mnt2 in `mount | grep ${NVME_DEVICE} | awk '{print $3}'`; do
      umount $mnt2
    done
  done

  swapoff /dev/mapper/swap
  cryptsetup close /dev/mapper/swap
  cryptsetup close /dev/mapper/root

  echo -n "Wiping ${NVME_DEVICE}..."
  blkdiscard -f -v ${NVME_DEVICE}
  echo "Done."

  echo -n "Creating partitions..."
  parted --script --machine --align=opt ${NVME_DEVICE} \
    mktable gpt \
    mkpart boot fat32 0% 8GiB \
    set 1 boot on \
    set 1 esp on \
    mkpart swap linux-swap 8GiB "$((${SWAP_SIZE_GIB} + 8))GiB" \
    mkpart root ext4 "$((${SWAP_SIZE_GIB} + 8))GiB" 100%
  echo "Done."

  # SWAP
  echo "--- SWAP setup"
  cryptsetup luksFormat --label swap --type luks2 --cipher aes-xts-plain64 --key-size 512 --verify-passphrase ${NVME_DEVICE}p2
  cryptsetup --allow-discards --persistent open ${NVME_DEVICE}p2 swap
  systemd-cryptenroll --tpm2-device auto ${NVME_DEVICE}p2
  systemd-cryptenroll --wipe-slot password ${NVME_DEVICE}p2
  echo "-- DONE WITH SWAP"

  # ROOT
  echo "--- ROOT setup"
  cryptsetup luksFormat --label root --type luks2 --cipher aes-xts-plain64 --key-size 512 --verify-passphrase ${NVME_DEVICE}p3
  cryptsetup --allow-discards --persistent open ${NVME_DEVICE}p3 root
  echo "-- DONE WITH ROOT"

  mkfs.fat -F 32 -n BOOT ${NVME_DEVICE}p1
  mkfs.btrfs -f /dev/mapper/root
  mkswap /dev/mapper/swap
  swapon /dev/mapper/swap

  mkdir -p /mnt
  mount -t btrfs /dev/mapper/root /mnt

  cd /mnt

  btrfs subvolume create "@root"
  btrfs subvolume create "@home"
  btrfs subvolume create "@nix"
  btrfs subvolume create "@docker"
  btrfs subvolume create "@log"

  cd /
  umount /mnt

  MOUNT_OPTS="ssd,rw,noatime,discard=async,compress=zstd,space_cache=v2,commit=120"
  mount -o ${MOUNT_OPTS},subvol=@root /dev/mapper/root /mnt
  mkdir -p /mnt/{boot,var/lib/docker,nix,var/log,home}

  mount -o rw,noatime ${NVME_DEVICE}p1 -t vfat /mnt/boot
  mount -o ${MOUNT_OPTS},subvol=@home -t btrfs /dev/mapper/root /mnt/home
  mount -o ${MOUNT_OPTS},subvol=@nix -t btrfs /dev/mapper/root /mnt/nix
  mount -o ${MOUNT_OPTS},subvol=@docker -t btrfs /dev/mapper/root /mnt/var/lib/docker
  mount -o ${MOUNT_OPTS},subvol=@log -t btrfs /dev/mapper/root /mnt/var/log

  btrfs subvolume snapshot -r /mnt /mnt/blank
fi
