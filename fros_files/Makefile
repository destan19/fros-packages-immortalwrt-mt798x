
include $(TOPDIR)/rules.mk

PKG_NAME:=fros_files
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/fros_files
  SECTION:=Fros Apps
  CATEGORY:=Fros Apps
  DEPENDS:=
  TITLE:=fros base files
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)

endef

define Build/Compile

endef	


define Build/Compile/Default

endef

define Package/$(PKG_NAME)/description
  fros base files
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/* $(1)/etc/uci-defaults/
	#$(INSTALL_DATA) ./files/etc/config/* $(1)/etc/config/
	$(INSTALL_DATA) ./files/etc/version $(1)/etc/
	$(INSTALL_DATA) ./files/etc/f_type $(1)/etc/
	$(INSTALL_DATA) ./files/etc/product_feature $(1)/etc/

endef


$(eval $(call BuildPackage,$(PKG_NAME)))

