#!/bin/sh

# Inspired from: http://jmlinnik.blogspot.com/2011/12/keystores.html
FILES=`find . -name "*.pk8"`

for FILE in $FILES; do
	FILE_NAME=`echo $FILE | awk -F.pk8 '{print $1}'`
	NAME=`basename $FILE_NAME`
	if [ -f ${FILE_NAME}.pem ] 
	then
		echo "file ${FILE_NAME}.pem exists"
	else
		`openssl pkcs8 -inform DER -nocrypt -in ${FILE} -out ${FILE_NAME}.pem`
	fi
	
	`openssl pkcs12 -export -in ${FILE_NAME}.x509.pem -out ${FILE_NAME}.p12 -inkey ${FILE_NAME}.pem -password pass:android -name ${NAME}`
	#`openssl pkcs12 -export -in ${FILE_NAME}.x509.pem -out ${FILE_NAME}.p12 -inkey ${FILE_NAME}.pem -password pass:android -name androiddebugkey`
done

# now generate the platform keystore

keytool -importkeystore -deststorepass android -destkeystore ./shared.jks -srckeystore ./shared.p12 -srcstoretype PKCS12 -srcstorepass android
keytool -importkeystore -deststorepass android -destkeystore ./testkey.jks -srckeystore ./testkey.p12 -srcstoretype PKCS12 -srcstorepass android
keytool -importkeystore -deststorepass android -destkeystore ./media.jks -srckeystore ./media.p12 -srcstoretype PKCS12 -srcstorepass android
keytool -importkeystore -deststorepass android -destkeystore ./platform.jks -srckeystore ./platform.p12 -srcstoretype PKCS12 -srcstorepass android
