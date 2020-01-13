# HTTPS on localhost
rm -rf ~/dev/certificates/
mkdir ~/dev/certificates/

openssl req -x509 -out ~/dev/certificates/localhost.crt -keyout ~/dev/certificates/localhost.key \
  -newkey rsa:2048 -days 3650 -nodes -sha256 \
  -subj '/C=US/ST=NJ/L=fdDev/O=fdLocalhost/CN=localhost' -extensions EXT -config <( \
   printf "[dn]\nCN=localhost\n[req]\ndistinguished_name=dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")

sudo cp ~/dev/certificates/localhost.pem ~/dev/certificates/localhost.crt
sudo cp ~/dev/certificates/localhost.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates

echo "Now go and set chrome://flags/#allow-insecure-localhost to be enabled"