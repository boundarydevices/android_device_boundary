#!/system/bin/sh

FW_PATH=`getprop sys.touch.fw.path`

echo "Setting up touchscreen with $FW_PATH" > /dev/console
/system/bin/mxt-app --load $FW_PATH

# changing reload value to show it is done
setprop sys.touch.fw.reload done
