#!/bin/bash

if [ "$1" = "" ]; then
  echo "Usage: $0 <RELEASE_PATH> [RELEASE_CHANNEL]"
  echo "The default password is empty string, default channel is 'alpha'."
  echo "Make sure you have ssh and sshpass..."
  echo "sudo apt-get install sshpass"
  exit 1
fi

MY_DIR=$(dirname "$0")
MY_NAME=$(basename "$0")
cd "$MY_DIR"

RELEASE_PATH="$1"
CHANNEL="${2-alpha}"
SSHOPT="-q -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

# Make sure we have the vars file
if [ ! -e "$RELEASE_PATH/release_vars" ]; then
  echo "Release vars file not found: $RELEASE_PATH/release_vars"
  cd -
  exit 1
fi

# pull in the vars
. "$RELEASE_PATH/release_vars"

if [ "$HARDWARE_ID" == "archer_c7_v2" ]; then
  IP="192.168.1.1"
  PASSWD="admin"
  FLASHING_TIME=45
else
  echo "No test setup for $HARDWARE_ID"
  cd -
  exit 1
fi

# Check the firmware file
FIRMWARE_FILE="$RELEASE_PATH/$UPGRADE_FILE"
if [ ! -e "$FIRMWARE_FILE" ]; then
  echo "Firmware file not found: $FIRMWARE_FILE"
  cd -
  exit 1
fi

# Testing
echo "Testing firmware upgrade for AP at '$IP', password '$PASSWD'..."

# Get the AP current firmware version
CURVER=`sshpass -p "$PASSWD" ssh $SSHOPT root@$IP -C "cat /etc/openwrt_release" | sed -n -e "s/DISTRIB_RELEASE='\(.*\)'/\1/p"`
if [ $? -ne 0 ]; then
  echo "Error: failed to get current firmware version from the AP!"
  cd -
  exit 1
fi
echo "AP firmvare version: $CURVER"

# Get the new firmware version
NEWVER=$FIRMWARE_VERSION
echo "New firmvare version: $NEWVER"
if [ "$CURVER" = "$NEWVER" ]; then
  echo "Error: the new and current AP versions are the same!"
  cd -
  exit 3
fi

# Get the cloud configured firmware version for the requested channel
FIRMWARE_RELEASE_INFO_URL="https://releases.violetatrium.com/release_server/releases/${CHANNEL}/active/${HARDWARE_ID}_firmware"
STR=$(wget -q -O - "$FIRMWARE_RELEASE_INFO_URL")
CLOUDVER=${STR%%$'\n'*}
CLOUDVER=${CLOUDVER#v}
if [ "$CLOUDVER" = "" ]; then
  echo "Error: failed to get the new firmware version from the cloud:"
  echo "       $FIRMWARE_RELEASE_INFO_URL"
  cd -
  exit 4
fi
echo "Cloud firmware for ${DEVICE} channel ${CHANNEL} is of version: $CLOUDVER"

echo "Upgrading to the new test firmware $NEWVER, delay $FLASHING_TIME sec"
# Upgrade AP to the new version
./upgrade.sh $IP $PASSWD "$FIRMWARE_FILE" &
# Wait some time for the flashing to complete
sleep $FLASHING_TIME

# Start checking for completeted upgrade
TIMEOUT=120
TIME=$(cat /proc/uptime | sed -e 's/\..*//')
let "TIMELIMIT = $TIME + TIMEOUT"
UPGRADED=0
echo "Waiting for AP to flash and reboot (up to ${TIMEOUT}sec)..."
while [ $TIME -lt $TIMELIMIT ]; do 
  sleep 10
  APVER=`sshpass -p "$PASSWD" ssh $SSHOPT root@$IP -C "cat /etc/openwrt_release" | sed -n -e "s/DISTRIB_RELEASE='\(.*\)'/\1/p"`
  if [ $? -eq 0 ] && [ "$APVER" = "$NEWVER" ]; then
    UPGRADED=1
    break;
  fi
  TIME=$(cat /proc/uptime | sed -e 's/\..*//')
done
if [ $UPGRADED -ne 1 ]; then
  echo "Error: failed to upgrade to version $NEWVER"
  kill -9 %1
  cd -
  exit 6
fi
echo "AP was upgraded to $NEWVER, waiting for cloud to restore $CLOUDVER..."
kill -9 %1

# Wait for the cloud restore to finish (up to 11min, 8-max delay, 3-upgrade)
TIMEOUT=660
TIME=$(cat /proc/uptime | sed -e 's/\..*//')
let "TIMELIMIT = $TIME + TIMEOUT"
UPGRADED=0
echo "Waiting for AP to flash and reboot (up to ${TIMEOUT}sec)..."
while [ $TIME -lt $TIMELIMIT ]; do 
  sleep 30
  APVER=`sshpass -p "$PASSWD" ssh $SSHOPT root@$IP -C "cat /etc/openwrt_release" | sed -n -e "s/DISTRIB_RELEASE='\(.*\)'/\1/p"`
  if [ $? -eq 0 ] && [ "$APVER" = "$CLOUDVER" ]; then
    UPGRADED=1
    break;
  fi
  TIME=$(cat /proc/uptime | sed -e 's/\..*//')
done
if [ $UPGRADED -ne 1 ]; then
  echo "Error: failed to restore cloud firmware $CLOUDVER"
  echo "The last reported AP version is '$APVER'."
  cd -
  exit 7
fi
echo "AP was restored to $CLOUDVER, success!"

cd -
