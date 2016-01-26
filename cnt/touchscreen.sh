#!/system/bin/sh

TYPE=`getprop ro.build.type`

if [ "$TYPE" == "eng" ]; then
	echo "Setting up touchscreen" > /dev/console
	/system/bin/mxt-app --load /etc/firmware/TI768Board.xcfg
fi
