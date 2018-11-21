WIFI_MODULE ?= multiwifi

multiwifi:
	$(MAKE) WIFI_MODULE=$(WIFI_MODULE) -f hardware/amlogic/wifi/configs/wifi_driver.mk
