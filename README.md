# Simple mind map (Docker Containers)

[![Build Status](https://github.com/hraulein/mind-map/workflows/Multi-Platform%20Docker%20Build/badge.svg)](https://github.com/hraulein/mind-map/actions)
[![Docker Version](https://img.shields.io/docker/v/hraulein/mind-map/latest)](https://github.com/hraulein/mind-map/)
[![Docker Pulls](https://img.shields.io/docker/pulls/hraulein/mind-map)](https://hub.docker.com/r/hraulein/mind-map/)
[![Docker Image Size](https://img.shields.io/docker/image-size/hraulein/mind-map/latest)](https://hub.docker.com/r/hraulein/mind-map/)
[![GitHub issues](https://img.shields.io/github/issues/hraulein/mind-map)](https://github.com/hraulein/mind-map/issues)
[![npm-version](https://img.shields.io/npm/v/simple-mind-map)](https://www.npmjs.com/package/simple-mind-map)
![license](https://img.shields.io/npm/l/express.svg)

---

中文 | [English](./README_en.md)

- 本人非原项目作者, 仅构建 docker 镜像, 如遇项目 BUG 等请到 [Github/wanglin2](https://github.com/wanglin2/mind-map) 提相关 [issue](https://github.com/wanglin2/mind-map/issues) 

- 如在部署过程中遇到镜像启动失败等相关问题, 请提 [issue](https://github.com/hraulein/mind-map/issues) , 也可联系邮箱: [solitude@hraulein.com](mailto:solitude@hraulein.com)  

- 目前容器的运行环境为 `scratch`(不包含 `sh/bash`), 不影响 mind-map 的运行  
如需挂载你自定义的 ` 的静态文件, 将你的文件目录映射到容器内部的 `/app` 下即可

- 目前 `httpdGIN` 采用配置文件形式读取配置, 如需自定义配置, 请先将容器内部的 `/conf.d/` 目录拷贝出来后再挂载

## 使用方式

1\. `docker-compose.yaml`

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
  #   - ./your_dist_dir:/app    # 如果你想自定义 mind-map 的静态文件


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
  
    server_name mind-map.hraulein.localhost;   # <<< 替换为你的域名
    set $IPADDR 172.16.19.156;                 # <<< 替换为你服务器的内网 IP 地址

    location / {
        proxy_pass http://$IPADDR:8080;        # <<< 替换为 mind-map 服务实际映射端口
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Accept-Encoding gzip;
    }    
    # include ./conf.d/include/err_pages;
}
```

## [请我喝杯可乐](https://github.com/Hraulein/mind-map/issues/1#%E6%94%AF%E6%8C%81%E4%B8%80%E4%B8%8B)


