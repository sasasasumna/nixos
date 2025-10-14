#!/bin/bash

if [[ -z "${NVME_DEVICE}"]]; then
  echo "NVME_DEVICE must be set!"
  exit 1
fi

if [[ -z "${SWAP_SIZE_GIB}"]]; then
  echo "SWAP_SIZE_GIB must be set!"
  exit 1
fi

response = read "THIS WILL WIPE EVERYTHING ON ${NVME_DEVICE}! TYPE 'OKAY' IN ALL CAPS TO CONTINUE:"
if [ "$response" != "OKAY" ]; then
  echo "Did not receive an 'OKAY'. Aborting."
  exit 1
else
  echo -n "Wiping ${NVME_DEVICE}..."
  wipefs -a ${NVME_DEVICE}
  echo "Done."

  echo -n "Creating partitions..."
  parted --script --machine --align=opt ${NVME_DEVICE} \
    mktable gpt \
    mkpart boot fat32 0% 8GiB \
    set 1 boot on \
    set 1 esp on \
    mkpart crypt linux 8GiB 100%
  echo "Done."

  mkfs.fat -F 32 -n BOOT ${NVME_DEVICE}p1

  cryptsetup luksFormat --type luks2 --cipher aes-xts-plain64 --key-size 512 --verify-passphrase ${NVME_DEVICE}p2
  cryptsetup --allow-discards --label crypt --persistent open ${NVME_DEVICE}p2 root

  mkfs.btrfs /dev/mapper/root

  SUBVOLUMES=("/" "/home" "/nix" "/var/lib/docker" "/var/lib/machines" "/var/log")
  mount -t btrfs /dev/mapper/root /mnt
  for subvolume in "${SUBVOLUMES[@]}"; do
    btrfs subvolume create "/mnt${subvolume}"
  done
  btrfs subvolume create /mnt/swap
  btrfs subvolume snapshot -r /mnt/ /mnt/blank

  umount /mnt

  MOUNT_OPTS="ssd,rw,noatime,discard=async,compress=zstd,space_cache=v2,commit=120"
  mount -o ${MOUNT_OPTS},subvol=/ /dev/mapper/root /mnt
  for subvolume in "${SUBVOLUMES[@]}"; do
    mkdir -p "/mnt/${subvolume}"
    mount -o ${MOUNT_OPTS},subvol="${subvolume}" "/dev/mapper/root /mnt${subvolume}"
  done

  mkdir /mnt/swap
  mount -o ssd,rw,noatime,discard=async /dev/mapper/root /mnt/swap
  btrfs filesystem mkswapfile --size=${SWAP_SIZE_GIB}G /mnt/swap/swapfile

  mkdir /mnt/boot
  mount ${NVME_DEVICE}p1 /mnt/boot
fi
