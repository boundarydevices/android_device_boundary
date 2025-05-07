#!/bin/bash
set -e

if [ "$#" -ne 3 ]; then
    echo -e "Usage: $0 <private key file> <public key file>"
    exit 1
fi

PRIVATE_KEY_FILE=$1
PUBLIC_KEY_FILE=$2
ENCRYPT_KEY_FILE=$3

openssl ecparam \
    -genkey \
    -name prime256v1 \
    -noout \
    -outform DER \
    -out "$PRIVATE_KEY_FILE"

openssl ec \
    -inform DER \
    -in "$PRIVATE_KEY_FILE" \
    -pubout \
    -outform DER \
    -out "$PUBLIC_KEY_FILE"

# generate ase key
openssl rand 16 > "$ENCRYPT_KEY_FILE"
#openssl rand 16 -out aeskey.bin
