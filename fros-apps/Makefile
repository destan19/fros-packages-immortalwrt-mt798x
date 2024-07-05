
include $(TOPDIR)/rules.mk

PKG_NAME:=fros
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/fros
  SECTION:=Fros Apps
  CATEGORY:=Fros Apps
  DEPENDS:=+libuci +libjson-c +libblobmsg-json +libubox +libubus +libmosquitto +libcurl +openssl-util +luci +luci-compat +uhttpd
  TITLE:=fros
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	cp ./src/Makefile $(PKG_BUILD_DIR)
	@sh ./prepare.sh $(PKG_BUILD_DIR) $(CONFIG_TARGET_BOARD) $(CONFIG_TARGET_SUBTARGET) 
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR)/ \
	CC="$(TARGET_CROSS)gcc" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LIBS="$(TARGET_LDFLAGS) -lm -luci -ljson-c -luci_config -lblobmsg_json -lubox -lubus -lmosquitto -lcrypto -lcurl" \
	all
endef	


define Build/Compile/Default

endef

define Package/$(PKG_NAME)/description
  fros
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/appfilter
	$(INSTALL_DIR) $(1)/etc/tmp_config
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/oui
	$(INSTALL_DIR) $(1)/etc/app_delay
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_DIR) $(1)/www/cgi-bin
	$(INSTALL_DIR) $(1)/lib/modules

	$(CP) $(PKG_BUILD_DIR)/*.so $(1)/usr/lib/
	$(CP) ./files/configs/* $(1)/etc/config

	$(CP) ./files/tmp_oaf $(1)/etc/tmp_config/oaf
	$(CP) ./files/feature.bin $(1)/etc/appfilter/feature.bin
	$(CP) ./files/app_class.txt $(1)/etc/appfilter/
	$(INSTALL_DATA) ./files/oui/* $(1)/etc/oui
	$(INSTALL_BIN) ./files/appfilter.init $(1)/etc/init.d/appfilter
	$(INSTALL_BIN) ./files/test.init $(1)/etc/init.d/monitor
	$(INSTALL_BIN) ./files/oaf_rule $(1)/usr/bin
	$(INSTALL_BIN) ./files/gen_class.sh $(1)/usr/bin
	$(INSTALL_BIN) ./files/compat.sh $(1)/usr/bin
	$(INSTALL_BIN) ./files/wisp.sh $(1)/usr/bin
	$(INSTALL_BIN) ./files/gen_feature.sh $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/oafd $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ft_tool $(1)/usr/bin
	$(INSTALL_DATA) ./files/app_list $(1)/etc/app_delay
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/rule_apply $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fros $(1)/www/cgi-bin/
	$(CP) ./files/www/* $(1)/www/ -fr
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dpi_filter.ko $(1)/lib/modules/

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/apid $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/monitd $(1)/usr/bin
	$(INSTALL_BIN) ./files/apid.init $(1)/etc/init.d/apid_init
	$(INSTALL_BIN) ./files/license.init $(1)/etc/init.d/license
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/licensed $(1)/usr/bin
	$(INSTALL_BIN) ./files/qos.sh $(1)/etc/init.d/fros_qos
	$(INSTALL_BIN) ./files/qos.hotplug $(1)/etc/hotplug.d/iface/51-qos
	$(INSTALL_BIN) ./files/test.init $(1)/etc/init.d/monitor

endef


$(eval $(call BuildPackage,$(PKG_NAME)))

