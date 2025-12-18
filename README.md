# ip_https_cert

# IP HTTPS 证书生成工具

这是一个用于生成基于IP地址的HTTPS证书的工具集，支持自签名CA证书生成、服务器证书生成和PFX格式证书转换。

## 功能特性

- 🔐 生成自签名CA证书
- 📜 生成基于IP地址的服务器HTTPS证书
- 🔄 支持PFX格式证书转换
- 🐳 包含Docker部署脚本
- ⚙️ 完整的Nginx配置示例
- 📝 详细的中文使用文档

## 项目结构

```
ip_https_cert/
├── README.md                      # 项目说明文档
├── LICENSE                        # 木兰宽松许可证第2版
├── gen_ip_https_cert.sh          # 主脚本：生成IP HTTPS证书
├── gen_pfx.sh                     # 脚本：生成PFX格式证书
├── deploy_site.sh                 # 脚本：部署网站（Docker）
├── 自定义服务器https证书.md           # 中文详细说明文档
└── site/                          # 网站相关文件
    ├── conf.d/
    │   └── site.conf              # Nginx配置文件
    ├── html/
    │   └── index.html             # 示例网页
    └── logs/                      # 日志目录
```

## 快速开始

### 1. 生成IP HTTPS证书

运行主脚本，按提示输入IP地址和证书年限：

```bash
./gen_ip_https_cert.sh
```

脚本会提示输入：
- 服务器IP地址
- 证书年限（自动转换为天数）

生成的文件：
- `ca.key` - CA私钥
- `ca.crt` - CA证书
- `server.key` - 服务器私钥
- `server.crt` - 服务器证书

### 2. 生成PFX格式证书

```bash
./gen_pfx.sh
```

这将生成 `server.pfx` 文件，适用于需要PFX格式的Windows服务器或IIS。

### 3. 部署网站（可选）

使用提供的Docker脚本部署Nginx网站：

```bash
./deploy_site.sh
```

**注意**：部署脚本中的路径为硬编码路径，需要根据实际情况修改：
```bash
-v /Users/andyge/Desktop/lesson/https_cert/site/html:/usr/share/nginx/html
-v /Users/andyge/Desktop/lesson/https_cert/site/cert:/etc/nginx/cert
-v /Users/andyge/Desktop/lesson/https_cert/site/logs:/var/log/nginx
-v /Users/andyge/Desktop/lesson/https_cert/site/conf.d:/etc/nginx/conf.d
```

## 证书生成原理

### 1. 生成CA证书
```bash
# 生成CA私钥
openssl genrsa -out ca.key 2048

# 生成CA证书
openssl req -new -x509 -days 3650 -key ca.key -out ca.crt
```

### 2. 生成服务器证书

- 创建OpenSSL配置文件（`openssl.cnf`），包含IP Subject Alternative Names
- 生成服务器私钥和证书签名请求（CSR）
- 使用CA证书对服务器证书进行签名

### 3. 生成PFX证书
```bash
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt
```

## 配置说明

### Nginx配置要点

`site/conf.d/site.conf` 包含：
- HTTP到HTTPS重定向
- SSL证书配置
- 基本的HTTP头设置
- GZIP压缩配置

关键配置：
```nginx
ssl_certificate /etc/nginx/cert/server.crt;
ssl_certificate_key /etc/nginx/cert/server.key;
ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
```

## 使用场景

- 开发环境中的HTTPS测试
- 内网服务的HTTPS加密
- 临时环境的安全访问
- 学习HTTPS证书生成过程

## 注意事项

⚠️ **重要提醒**：
- 这是自签名证书，浏览器会显示安全警告
- 仅适用于测试、开发和内网环境
- 生产环境请使用由受信任CA颁发的证书
- 部署脚本中的路径需要根据实际环境调整

## 许可证

本项目采用 [木兰宽松许可证第2版](http://license.coscl.org.cn/MulanPSL2) 开源协议。

## 依赖要求

- OpenSSL
- Docker（可选，用于部署）
- Nginx（如果手动部署）

## 技术细节

### OpenSSL配置
- 支持IP Subject Alternative Names (SAN)
- 默认2048位RSA密钥
- 支持SHA256签名算法
- 可配置证书有效期

### 安全特性
- TLS 1.0/1.1/1.2支持
- 强密码套件配置
- 适当的密钥用途设置

## 贡献

欢迎提交Issue和Pull Request来改进这个项目。

## 作者

masx200

---

*如需详细的手动操作步骤，请参考项目中的 `自定义服务器https证书.md` 文件。*
