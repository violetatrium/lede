#!/bin/bash

# See ../feeds.conf.default to make sure the commands here
# still match to the location of the feeds needed.

BRANCH=openwrt-18.06

src-git packages https://git.openwrt.org/feed/packages.git^340d5ce71ee60c1d699e7e0ead9422bed6f8519f
src-git luci https://git.openwrt.org/project/luci.git^bc17ef673f734ea8e7e696ba5735588da9111dcd
src-git routing https://git.openwrt.org/feed/routing.git^c52779c05a4cf838c736327d8b042ee59f782331
src-git telephony https://git.openwrt.org/feed/telephony.git^06a5323734038c3866f507787256581dba3d8522

rm -Rf ./packages ./luci ./routing ./telephony
git clone -b $BRANCH https://git.lede-project.org/feed/packages.git
git -C packages checkout 340d5ce71ee60c1d699e7e0ead9422bed6f8519f
git clone -b $BRANCH https://git.lede-project.org/project/luci.git
git -C luci checkout bc17ef673f734ea8e7e696ba5735588da9111dcd
git clone -b $BRANCH https://git.lede-project.org/feed/routing.git
git -C routing checkout c52779c05a4cf838c736327d8b042ee59f782331
git clone -b $BRANCH https://git.lede-project.org/feed/telephony.git
git -C telephony checkout 06a5323734038c3866f507787256581dba3d8522
rm -Rf ./packages/.git ./luci/.git ./routing/.git ./telephony/.git
rm -Rf ./packages/.github ./luci/.github ./routing/.github ./telephony/.github

