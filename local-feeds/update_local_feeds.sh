#!/bin/bash

# See ../feeds.conf.default to make sure the commands here
# still match to the location of the feeds needed.

BRANCH="openwrt-19.07"

#src-git packages https://git.openwrt.org/feed/packages.git^2e6bd4cb86682b224803325127d3f777d40b3231
#src-git luci https://git.openwrt.org/project/luci.git^fb2f36306756d0d0782dcab8413a8bb7ec379e54
#src-git routing https://git.openwrt.org/feed/routing.git^3f8571194c2765ed31aa73459e86c2ebf943d27d
#src-git telephony https://git.openwrt.org/feed/telephony.git^036cd451c35b82b3d8cac519864986894d9f6958

rm -Rf ./packages ./luci ./routing ./telephony
git clone -b $BRANCH https://git.lede-project.org/feed/packages.git
git -C packages checkout 2e6bd4cb86682b224803325127d3f777d40b3231
git clone -b $BRANCH https://git.lede-project.org/project/luci.git
git -C luci checkout fb2f36306756d0d0782dcab8413a8bb7ec379e54
git clone -b $BRANCH https://git.lede-project.org/feed/routing.git
git -C routing checkout 3f8571194c2765ed31aa73459e86c2ebf943d27d
git clone -b $BRANCH https://git.lede-project.org/feed/telephony.git
git -C telephony checkout 036cd451c35b82b3d8cac519864986894d9f6958
rm -Rf ./packages/.git ./luci/.git ./routing/.git ./telephony/.git
rm -Rf ./packages/.github ./luci/.github ./routing/.github ./telephony/.github

