```
#!/bin/bash

# DIY
HOST=*.hello233world.com
PASWD=PASSWORD


echo "生成CA密钥:ca-key.pem"
openssl genrsa -passout pass:$PASWD -aes256 -out ca-key.pem 4096

echo "生成CA证书:ca.pem"
openssl req -passin pass:$PASWD -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem -subj "/CN=$HOST"

echo "生成服务端密钥:server-key.pem"
openssl genrsa -out server-key.pem 4096

echo "生成服务端证书请求:server.csr"
openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr

echo "生成服务端证书:server-cert.pem"
echo extendedKeyUsage = serverAuth > extfile_server.cnf
openssl x509 -passin pass:$PASWD -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile_server.cnf
rm server.csr

echo "生成客户端密钥:key.pem"
openssl genrsa -out key.pem 4096

echo "生成客户端证书请求:client.csr"
openssl req -subj '/CN=client' -new -key key.pem -out client.csr

echo "生成客户端证书:cert.pem"
echo extendedKeyUsage = clientAuth > extfile_client.cnf
openssl x509 -passin pass:$PASWD -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile_client.cnf

rm -f client.csr server.csr ca.srl extfile_client.cnf extfile_server.cnf

```