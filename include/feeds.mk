#
# Copyright (C) 2014 OpenWrt.org
# Copyright (C) 2016 LEDE Project
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

-include $(TMP_DIR)/.packagesubdirs

FEEDS_INSTALLED:=$(notdir $(wildcard $(TOPDIR)/package/feeds/*))
FEEDS_AVAILABLE:=$(sort $(FEEDS_INSTALLED) $(shell $(SCRIPT_DIR)/feeds list -n))

# List feeds that shoud not be added to opkg & imagebuilder feed sources lists
# The FeedSourcesAppend was modified to exclude these.
FEEDS_NO_REMOTE:=minim

PACKAGE_SUBDIRS=$(PACKAGE_DIR)
ifneq ($(CONFIG_PER_FEED_REPO),)
  PACKAGE_SUBDIRS += $(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/base
  PACKAGE_SUBDIRS += $(foreach FEED,$(FEEDS_AVAILABLE),$(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/$(FEED))
endif

opkg_package_files = $(wildcard \
	$(foreach dir,$(PACKAGE_SUBDIRS), \
	  $(foreach pkg,$(1), $(dir)/$(pkg)_*.ipk)))

# 1: package name
define FeedPackageDir
$(strip $(if $(CONFIG_PER_FEED_REPO), \
  $(if $(Package/$(1)/subdir), \
    $(abspath $(OUTPUT_DIR)/packages/$(ARCH_PACKAGES)/$(Package/$(1)/subdir)), \
    $(PACKAGE_DIR)), \
  $(PACKAGE_DIR)))
endef

# 1: destination file
define FeedSourcesAppend
( \
  echo 'src/gz %d_core %U/targets/%S/packages'; \
  $(strip $(if $(CONFIG_PER_FEED_REPO), \
	$(foreach feed,base $(filter-out $(FEEDS_NO_REMOTE),$(FEEDS_ENABLED)),echo "src/gz %d_$(feed) %U/packages/%A/$(feed)";) \
	$(if $(CONFIG_PER_FEED_REPO_ADD_DISABLED), \
		$(foreach feed,$(filter-out $(FEEDS_NO_REMOTE),$(FEEDS_DISABLED)),echo "$(if $(CONFIG_PER_FEED_REPO_ADD_COMMENTED),# )src/gz %d_$(feed) %U/packages/%A/$(feed)";)))) \
) >> $(1)
endef
