#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: $0 [-c|-n] <AP_IP_ADDRESS> [SSH_KEY_FILE] [FIRMWARE_FILE]"
  echo "The key file in ~/.ssh/config is used by default. The default firmware file"
  echo "is determined by looking up the ./.config file. Options:"
  echo "-c - attempt to preserve all changed files in /etc/"
  echo "-n - do not save configuration over reflash"
  exit 1
fi

MY_DIR=$(dirname "$0")
cd "$MY_DIR"
MY_DIR="$PWD"

OPTIONS=""
while [ "${1:0:1}" == "-" ]; do
  OPTIONS="$OPTIONS $1"
  shift
done

IP="$1"
SSH_KEY_FILE="$2"

if [ "$3" != "" ]; then
  FIRMWARE_FILE="$3"
else
  if [ ! -e "$MY_DIR/.config" ]; then
    echo "No $MY_DIR/.config file!"
    exit 2
  fi
  eval `grep CONFIG_TARGET_BOARD= .config`
  eval `grep CONFIG_TARGET_SUBTARGET= .config`
  BOARD=$CONFIG_TARGET_BOARD
  SUBTARGET=${CONFIG_TARGET_SUBTARGET:-generic}
  if [ "$BOARD" == "" ] || [ "$SUBTARGET" == "" ]; then
    echo "Unable to determine BOARD and SUBTARGET names for the build!"
    exit 3
  fi
  FIRMWARE_DIR="$MY_DIR"/bin/targets/$BOARD/$SUBTARGET
  FIRMWARE_FILE=`ls -t -1 "$FIRMWARE_DIR"/minim-*-sysupgrade.bin | head -1`
fi

if [ ! -e "$FIRMWARE_FILE" ]; then
  echo "Firmware file not found:\n'$FIRMWARE_FILE'"
  exit 4
fi

SSHOPT="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
if [ "$SSH_KEY_FILE" != "" ]; then
  SSHOPT="$SSHOPT -i $SSH_KEY_FILE"
fi

# Get the AP current firmware version
echo "AP current firmvare version:"
ssh $SSHOPT root@$IP -C "cat /etc/openwrt_release"
if [ $? -ne 0 ]; then
  echo "Error: failed to get current firmware version from the AP!"
  cd -
  exit 5
fi

echo "Uploading the firmware..."
echo "Firmware file: $FIRMWARE_FILE"
scp $SSHOPT "$FIRMWARE_FILE" root@$IP:/tmp/firmware.bin
if [ $? -ne 0 ]; then
  echo "Error: failed to upload the firmware file to AP!"
  exit 6
fi
echo "Sending command to flash the new firmware..."
echo "ssh $SSHOPT root@$IP -C \"/sbin/sysupgrade $OPTIONS /tmp/firmware.bin\""
ssh $SSHOPT root@$IP -C "/sbin/sysupgrade $OPTIONS /tmp/firmware.bin"

