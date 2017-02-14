#!/system/bin/sh

# Initializing the GPIO
echo  33 > /sys/class/gpio/export
echo  36 > /sys/class/gpio/export
echo 101 > /sys/class/gpio/export
echo 206 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio33/direction
echo out > /sys/class/gpio/gpio36/direction
echo out > /sys/class/gpio/gpio101/direction
echo  in > /sys/class/gpio/gpio206/direction
chmod -R go+w /sys/class/gpio/
