#!/bin/bash

# See ../feeds.conf.default to make sure the commands here
# still match to the location of the feeds needed.

BRANCH=openwrt-19.07

#src-git packages https://git.openwrt.org/feed/packages.git^00803ffc91e80b16e9c1603ff32106d42e255923
#src-git luci https://git.openwrt.org/project/luci.git^039ef1f4deba725d3591b159bbc9569885d68131
#src-git routing https://git.openwrt.org/feed/routing.git^8d5ee29f088e9dfaa49dc74573edb1919f14dbf4
#src-git telephony https://git.openwrt.org/feed/telephony.git^44d82fa226dc36a53043fdffdb9688d34a16a18c

rm -Rf ./packages ./luci ./routing ./telephony
git clone -b $BRANCH https://git.lede-project.org/feed/packages.git
git -C packages checkout 00803ffc91e80b16e9c1603ff32106d42e255923
git clone -b $BRANCH https://git.lede-project.org/project/luci.git
git -C luci checkout 039ef1f4deba725d3591b159bbc9569885d68131
git clone -b $BRANCH https://git.lede-project.org/feed/routing.git
git -C routing checkout 8d5ee29f088e9dfaa49dc74573edb1919f14dbf4
git clone -b $BRANCH https://git.lede-project.org/feed/telephony.git
git -C telephony checkout 44d82fa226dc36a53043fdffdb9688d34a16a18c
rm -Rf ./packages/.git ./luci/.git ./routing/.git ./telephony/.git
rm -Rf ./packages/.github ./luci/.github ./routing/.github ./telephony/.github

