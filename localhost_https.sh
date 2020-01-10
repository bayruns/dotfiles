# HTTPS on localhost
openssl genrsa -des3 -out rootSSL.key 2048
openssl req -x509 -new -nodes -key rootSSL.key -sha256 -days 1024 -out rootSSL.pem
sudo mkdir /usr/local/share/ca-certificates/extra
sudo cp rootSSL.pem \
/usr/local/share/ca-certificates/extra/rootSSL.crt
sudo update-ca-certificates

mkdir ~/dev/certificates/

openssl req -x509 -out ~/dev/certificates/localhost.crt -keyout ~/dev/certificates/localhost.key \
  -newkey rsa:2048 -nodes -sha256 \
  -subj '/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

sudo cp ~/dev/certificates/localhost.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates