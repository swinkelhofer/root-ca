#!/bin/sh

if [$1 = ""] 
then
echo "Usage: ./newssl.sh <Pathname>\nWhere Pathname should be the name of the Unit to create a new SSL-Cert"
exit 1
fi

echo "Enter the domains to register the certificate.\nForm has to be: DNS:erste.domain.xx,DNS:zweite.domain.xx"
read line
echo "subjectAltName=" $line > domains.txt

cd ssl
mkdir $1
cd $1
mkdir private public
openssl genrsa -out private/privkey.pem 4096
chmod -R 700 private/privkey.pem
openssl req -new -key private/privkey.pem -out cert-req.pem -config ../../caconfig.cnf
cd ../..
openssl x509 -days 3650 -CA certs/cacert.pem -CAkey private/cakey.pem -req -in ssl/$1/cert-req.pem -outform PEM -out ssl/$1/public/cert.pem -CAserial serial -extfile domains.txt
rm ssl/$1/cert-req.pem
rm domains.txt
