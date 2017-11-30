#
# Copyright (C) 2017 minim.co
#

include $(TOPDIR)/rules.mk

PKG_NAME:=unum
PKG_VERSION:=v2
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/unum
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Unum-v2 agent
  URL:=http://www.minim.co
  MAINTAINER:=minim.co <support@minim.co>
  DEPENDS:=+libpthread +librt +libuci +jansson +libnl-tiny \
           +@LIBCURL_MBEDTLS
  # Unable to enforce LIBCURL_MBEDTLS and have binary package dependencies
  # at the same time (will have to figure out later). The conditional 
  # dependencies like +!LIBCURL_MBEDTLS:libcurl aren't helping.
endef

define Package/unum/description
 Unum-v2 agent is a software component allowing a wireless router to be 
 managed and continuously monitored by the Minim cloud. See http://www.minim.co
 for more details.
endef


# We build from the local sources only, here are defines to 
# replace if we decide to publish it and make a download tarball.
AGENT_SOURCE_DIR=$(MINIM_UNUM_DIR)/src/unum
AGENT_FILES_DIR=$(MINIM_UNUM_DIR)/files

# Path where we store sources and file in the LEDE build tree (making it the
# same as in our build system tree)
PKG_BUILD_DIR_UNUM=$(PKG_BUILD_DIR)/src/unum
PKG_BUILD_DIR_FILES=$(PKG_BUILD_DIR)/files

# Subdir where the agent sources are (where to cd to run make)
MAKE_PATH:=src/unum

# Agent MODEL name for all the unum agent builds from LEDE w/ sources
AGENT_MODEL_ID=lede_generic

# Agent hardware ID for this particular hardware target/subtarget/device
ifeq ($(CONFIG_VERSION_HWREV),)
  AGENT_HARDWARE_ID=$(patsubst "%",%,$(CONFIG_VERSION_PRODUCT))
else
  AGENT_HARDWARE_ID=$(patsubst "%",%,$(CONFIG_VERSION_PRODUCT))_$(patsubst "%",%,$(CONFIG_VERSION_HWREV))
endif

# Agent version. This is based on time if just the agent package is
# built. The normal firmware build overrides this w/ its version number.
ifeq ($(MINIM_VERSION_NUMBER),)
  AGENT_VERSION_NUMBER=$(shell date +"%y%m%d.%H%M.%S.0" | sed -E 's/\b0+([1-9][0-9]*)\b/\1/g')
else
  AGENT_VERSION_NUMBER=$(MINIM_VERSION_NUMBER)
endif

# This is needed to prevent polluting the source tree w/ LEDE build artefacts.
# If pulling sources from external tarball this step is not needed.
define Build/Prepare
	echo "Preparing: $(PKG_NAME)"
	mkdir -p "$(PKG_BUILD_DIR_UNUM)"
	cd "$(PKG_BUILD_DIR)/src/unum" && find -xtype l -exec rm -f {} \;
	cd "$(AGENT_SOURCE_DIR)" && find * -type d -exec mkdir -p "$(PKG_BUILD_DIR_UNUM)/{}" \;
	cd "$(AGENT_SOURCE_DIR)" && find * \( -type f -o -type l \) -exec ln -sf "$(AGENT_SOURCE_DIR)/{}" "$(PKG_BUILD_DIR_UNUM)/{}" \;
	ln -s "$(AGENT_FILES_DIR)" "$(PKG_BUILD_DIR_FILES)"
endef

# We do not have configure (stop LEDE from even trying it)
define Build/Configure
endef

define Build/Compile
	$(call Build/Compile/Default,\
	  AGENT_VERSION=$(patsubst "%",%,$(AGENT_VERSION_NUMBER))\
	  MODEL=$(AGENT_MODEL_ID) HARDWARE=$(AGENT_HARDWARE_ID)\
	  TARGET_OBJ="$(PKG_BUILD_DIR)/src")
endef

define Package/unum/install
	echo "Install step"
	this is an error, stop !!!
	#$(INSTALL_DIR) $(1)/usr/sbin
	#$(INSTALL_BIN) $(PKG_BUILD_DIR)/ndppd $(1)/usr/sbin/
	#$(INSTALL_CONF) $(PKG_BUILD_DIR)/ndppd.conf-dist $(1)/etc/ndppd.conf
endef

$(eval $(call BuildPackage,unum))
