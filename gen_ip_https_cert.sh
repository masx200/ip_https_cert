#! /bin/bash

echo "请输入服务器IP地址"
read ip 

echo "请输入证书年限"
read year

year=$(expr $year + 0)

days=$(expr $year \* 365)

# echo $days

# # 生成私钥
openssl genrsa -out ca.key 2048

# 生成公钥
openssl req -new -x509 -days $days -key ca.key -out ca.crt -subj "//C=CN/C=CN/ST=BJ/L=SJS/O=GuFei/OU=dev/CN=jiehuo.com"

# 创建 openssl.cnf 配置文件
cat << EOF > openssl.cnf
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
organizationalName  = Organizational Name (eg, section)
organizationalName_default  = gufei
organizationalUnitName  = Organizational Unit Name (eg, section)
organizationalUnitName_default  = dev
commonName = Common Name (eg, your name or your server's hostname)
commonName_max  = 64

[v3_req]
# Extensions to add to a certificate request
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
IP.1 = $ip 
EOF

# 创建v3.ext文件
cat << EOF > v3.ext 
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage=digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName=@alt_names
[alt_names]
IP.1 = $ip 
EOF

# 服务器证书私钥
openssl genrsa -out server.key 2048

# 服务器证书公钥
openssl req -new -days $days -key server.key -out server.csr -config openssl.cnf -subj //C=CN/C=CN/ST=BJ/L=SJS/O=GuFei/OU=dev/CN=jiehuo.com

# 用自己的 CA 给自己的服务器签名
openssl x509 -days $days -req -sha256 -extfile v3.ext -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt

rm {ca.key,ca.srl,server.csr,openssl.cnf,v3.ext}
