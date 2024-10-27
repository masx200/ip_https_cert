# 1. 生成基于 IP 地址的 https 证书

## 1.1. 生成私钥

```sh
openssl genrsa -out ca.key 2048
```

## 1.2. 通过私钥创建公钥

```sh
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```

## 1.3. 创建 openssl.cnf 配置文件，只修改 alt_names 即可

```cnf
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = US
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = NY
localityName = Locality Name (eg, city)
localityName_default = NYC
organizationalUnitName  = Organizational Unit Name (eg, section)
organizationalUnitName_default  = xxx
commonName = xxx
commonName_max  = 64

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = 192.168.1.14
```

## 1.4. v3.ext 文件，只需要 alt_names 与上面的一致即可

```ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName=@alt_names
[alt_names]
IP.1 = 192.168.1.14
```

## 1.5. 服务器证书私钥

```sh
openssl genrsa -out server.key 2048
```

## 1.6. 服务器证书公钥

```sh
openssl req -new -days 3650 -key server.key -out server.csr -config openssl.cnf
```

## 1.7. 用自己的 CA 给自己的服务器签名

```sh
openssl x509 -days 3650 -req -sha256 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt
```
