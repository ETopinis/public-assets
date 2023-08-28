#!/bin/bash

IMAGE_URL="https://huggingface.co/ngxson/windows-10-ggcloud/resolve/main/windows-10-ggcloud.raw.gz"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt update && apt install -y util-linux curl wget nano sudo fdisk wget pigz

echo ""
echo ""
echo "    DOWNLOADING WINDOWS IMAGE FILE..."
echo ""
echo ""

wget -O windows.raw.gz $IMAGE_URL

echo ""
echo ""
echo "    COPYING IMAGE FILE... (may take about 5 minutes)"
echo "    Do NOT close this terminal until it finishes"
echo ""
echo ""

# get all block devices, sort by SIZE to get the biggest device
DESTINATION_DEVICE="/dev/"$(lsblk -x SIZE -o NAME,SIZE | tail -n1 | cut -d ' ' -f 1)

# then, use dd to copy image
echo "Destination device is $DESTINATION_DEVICE"
pigz -dc ./windows.raw.gz | sudo dd of=$DESTINATION_DEVICE bs=4M

echo ""
echo ""
echo "    COPY OK"
echo ""
echo ""

# print the partition table
echo "Partition table:"
fdisk -l

echo ""
echo ""
echo "    === ALL DONE ==="
echo ""
echo ""
