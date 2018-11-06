#!/bin/bash

# See ../feeds.conf.default to make sure the commands here
# still match to the location of the feeds needed.

BRANCH=openwrt-18.06

#src-git packages https://git.openwrt.org/feed/packages.git^35e0b737ab496f5b51e80079b0d8c9b442e223f5
#src-git luci https://git.openwrt.org/project/luci.git^f64b1523447547032d5280fb0bcdde570f2ca913
#src-git routing https://git.openwrt.org/feed/routing.git^1b9d1c419f0ecefda51922a7845ab2183d6acd76
#src-git telephony https://git.openwrt.org/feed/telephony.git^b9d7b321d15a44c5abb9e5d43a4ec78abfd9031b

rm -Rf ./packages ./luci ./routing ./telephony
git clone -b $BRANCH https://git.lede-project.org/feed/packages.git
git -C packages checkout 35e0b737ab496f5b51e80079b0d8c9b442e223f5
git clone -b $BRANCH https://git.lede-project.org/project/luci.git
git -C luci checkout f64b1523447547032d5280fb0bcdde570f2ca913
git clone -b $BRANCH https://git.lede-project.org/feed/routing.git
git -C routing checkout 1b9d1c419f0ecefda51922a7845ab2183d6acd76
git clone -b $BRANCH https://git.lede-project.org/feed/telephony.git
git -C telephony checkout b9d7b321d15a44c5abb9e5d43a4ec78abfd9031b
rm -Rf ./packages/.git ./luci/.git ./routing/.git ./telephony/.git
rm -Rf ./packages/.github ./luci/.github ./routing/.github ./telephony/.github

