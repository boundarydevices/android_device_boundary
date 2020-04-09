#!/bin/bash

touch rpmb_key.bin
#the rpmb key should be started with magic "RPMB"
echo -n "RPMB"  > rpmb_key.bin
#generate 32 bytes random numbers
head -c 32 /dev/urandom >> rpmb_key.bin
