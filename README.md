# Simple mind map (Docker Containers)

[![Build Status](https://github.com/hraulein/mind-map/workflows/Multi-Platform%20Docker%20Build/badge.svg)](https://github.com/hraulein/mind-map/actions)
[![Docker Version](https://img.shields.io/docker/v/hraulein/mind-map/latest)](https://github.com/hraulein/mind-map/)
[![Docker Pulls](https://img.shields.io/docker/pulls/hraulein/mind-map)](https://hub.docker.com/r/hraulein/mind-map/)
[![Docker Image Size](https://img.shields.io/docker/image-size/hraulein/mind-map/latest)](https://hub.docker.com/r/hraulein/mind-map/)
[![GitHub issues](https://img.shields.io/github/issues/hraulein/mind-map)](https://github.com/hraulein/mind-map/issues)
[![npm-version](https://img.shields.io/npm/v/simple-mind-map)](https://www.npmjs.com/package/simple-mind-map)
![license](https://img.shields.io/npm/l/express.svg)

---

# 客户端和插件

- 思绪思维导图客户端

支持Windows、Mac及Linux系统。下载地址：[Github](https://github.com/wanglin2/mind-map/releases)、[百度网盘](https://pan.baidu.com/s/1C8phEJ5pagAAa-o1tU42Uw?pwd=jqfb)、[夸克网盘](https://pan.quark.cn/s/2733982f1976)

- Obsidian插件

下载地址：[Github](https://github.com/wanglin2/obsidian-simplemindmap/releases)

- UTools插件

已上架[uTools](https://www.u.tools/)插件应用市场，可直接在`uTools`插件应用市场中搜索`思绪`进行安装，也可以直接访问该地址：[主页](https://www.u-tools.cn/plugins/detail/%E6%80%9D%E7%BB%AA%E6%80%9D%E7%BB%B4%E5%AF%BC%E5%9B%BE/)，点击右侧的【启动】按钮进行安装

# 库

---

基于 `Gin` 框架构建跨平台 `HTTP` 服务，通过 `Docker` 的多平台构建能力，实现 `mind-map` 在不同硬件架构上运行使用。

* 跨平台兼容：支持 `amd64` `arm64 | arm/v8` `arm/v7`
* 开箱即用：预配置 `mind-map` 静态文件，无需额外运行时依赖

在线地址: https://mind-map.hraulein.com  
镜像地址: https://hub.docker.com/r/hraulein/mind-map

- 云存储版本，如果你需要带后端的云存储版本，可以尝试我们开发的另一个项目[理想文档](https://github.com/wanglin2/lx-doc)。

```
services:
  mind-map:
    image: hraulein/mind-map:latest
    container_name: mind-map
    restart: always
    ports:
      - "8080:8080"  
    volumes:                   
      - ./your_config_dir:/conf.d
  #   - ./your_dist_dir:/app                               # 如果你想自定义 mind-map 的静态文件


```

2\. `docker cli`

```
docker run -d --name mind-map -p 8080:8080 -v ./your_config_dir:/conf.d hraulein/mind-map:latest
```

## nginx 配置参考

- `HTTP` 重定向 `HTTPS` 

```
# /etc/nginx/conf.d/00-redirect.conf

server {
    listen 80 default_server;
    listen [::]:80 default_server;
    return 301 https://$host$request_uri;
}
```

- `SSL` 证书相关配置  

``` 
# /etc/nginx/conf.d/include/ssl_parameter

ssl_certificate '/etc/nginx/*****/*****/fullchain.cer';    # <<< 替换为实际的证书地址
ssl_certificate_key '/etc/nginx/*****/*****/*****.key';    # <<< 替换为实际的证书地址
ssl_trusted_certificate '/etc/nginx/*****/*****/ca.cer';   # <<< 替换为实际的证书地址
ssl_session_cache shared:SSL:1m;
ssl_session_timeout 10m;
ssl_session_tickets off;
ssl_prefer_server_ciphers on;
ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256';
ssl_protocols TLSv1.2 TLSv1.3;
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 1.1.1.1 valid=300s;
resolver_timeout 5s;
add_header Strict-Transport-Security "max-age=31536000" always;
```

- `nginx` 反向代理配置

``` 
# /etc/nginx/conf.d/mind-map.conf

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    include ./conf.d/include/ssl_parameter;  
  
    server_name mind-map.hraulein.localhost;               # <<< 替换为你的域名
    set $IPADDR 172.16.19.156;                             # <<< 替换为你服务器的内网 IP 地址

    location / {
        proxy_pass http://$IPADDR:8080;                    # <<< 替换为 mind-map 服务实际映射端口
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
    }    
    # include ./conf.d/include/err_pages;
}
```

## 支持一下

如果 Docker 镜像对你有帮助 , 不妨请我喝杯阔落解解馋~

![Image](https://github.com/user-attachments/assets/a27ed620-30a3-460d-85b2-6fa869a91780)
