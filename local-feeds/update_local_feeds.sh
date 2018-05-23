#!/bin/bash

# See ../feeds.conf.default to make sure the commands here
# still match to the location of the feeds needed.

BRANCH=openwrt-18.06

rm -Rf ./packages ./luci ./routing ./telephony
git clone -b $BRANCH --depth 1 https://git.lede-project.org/feed/packages.git
git clone -b $BRANCH --depth 1 https://git.lede-project.org/project/luci.git
git clone -b $BRANCH --depth 1 https://git.lede-project.org/feed/routing.git
git clone -b $BRANCH --depth 1 https://git.lede-project.org/feed/telephony.git
rm -Rf ./packages/.git ./luci/.git ./routing/.git ./telephony/.git
rm -Rf ./packages/.github ./luci/.github ./routing/.github ./telephony/.github

