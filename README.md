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

---

基于 `Gin` 框架构建跨平台 `HTTP` 服务，通过 `Docker` 的多平台构建能力，实现 `mind-map` 在不同硬件架构上运行使用。

* 跨平台兼容：支持 `amd64` `arm64 | arm/v8` `arm/v7`
* 开箱即用：预配置 `mind-map` 静态文件，无需额外运行时依赖

在线地址: https://mind-map.hraulein.com  
镜像地址: https://hub.docker.com/r/hraulein/mind-map

如在部署过程中遇到镜像启动失败等相关问题, 请提 [issue](https://github.com/hraulein/mind-map/issues)

- 目前容器的运行环境为 `scratch`(不包含 `sh/bash`), 不影响 mind-map 的运行  
如需挂载你自定义的 `mind-map` 的静态文件, 将你的文件目录映射到容器内部的 `/app` 下即可

- 目前 `httpdGIN` 采用配置文件形式读取配置, 如需自定义配置, 请先将容器内部的 `/conf.d/` 目录拷贝出来后再挂载

> 3.`obsidian`插件，正在开发中，敬请期待~

- 云存储版本，如果你需要带后端的云存储版本，可以尝试我们开发的另一个项目[理想文档](https://github.com/wanglin2/lx-doc)。

1\. `docker-compose.yaml`

- [x] 插件化架构，除核心功能外，其他功能作为插件提供，按需使用，减小打包体积
- [x] 支持逻辑结构图（向左、向右逻辑结构图）、思维导图、组织结构图、目录组织图、时间轴（横向、竖向）、鱼骨图等结构
- [x] 内置多种主题，允许高度自定义样式，支持注册新主题
- [x] 节点内容支持文本（普通文本、富文本）、图片、图标、超链接、备注、标签、概要、数学公式
- [x] 节点支持拖拽（拖拽移动、自由调整）、多种节点形状；支持扩展节点内容、支持使用 DDM 完全自定义节点内容
- [x] 支持画布拖动、缩放
- [x] 支持鼠标按键拖动选择和 Ctrl+左键两种多选节点方式
- [x] 支持导出为`json`、`png`、`svg`、`pdf`、`markdown`、`xmind`、`txt`，支持从`json`、`xmind`、`markdown`导入
- [x] 支持快捷键、前进后退、关联线、搜索替换、小地图、水印、滚动条、手绘风格、彩虹线条、标记、外框
- [x] 提供丰富的配置，满足各种场景各种使用习惯
- [x] 支持协同编辑
- [x] 支持演示模式
- [x] 更多功能等你来发现

官方提供了如下插件，可根据需求按需引入（某个功能不生效大概率是因为你没有引入对应的插件），具体使用方式请查看文档：

| RichText（节点富文本插件）           | Select（鼠标多选节点插件）                | Drag（节点拖拽插件）                 | AssociativeLine（关联线插件）        |
| ------------------------------------ | ----------------------------------------- | ------------------------------------ | ------------------------------------ |
| Export（导出插件）                   | KeyboardNavigation（键盘导航插件）        | MiniMap（小地图插件）                | Watermark（水印插件）                |
| TouchEvent（移动端触摸事件支持插件） | NodeImgAdjust（拖拽调整节点图片大小插件） | Search（搜索插件）                   | Painter（节点格式刷插件）            |
| Scrollbar（滚动条插件）              | Formula（数学公式插件）                   | Cooperate（协同编辑插件）            | RainbowLines（彩虹线条插件）         |
| Demonstrate（演示模式插件）          | OuterFrame（外框插件）                    | MindMapLayoutPro（思维导图布局插件） |                                      |


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

[MIT](./LICENSE)。保留`simple-mind-map`版权声明和注明来源的情况下可随意商用，如有疑问或不想保留可联系作者通过付费的方式去除。

> 示例：可以在你应用中的关于页面、帮助页面、文档页面、开源声明等任何页面添加以下内容：
>
> 本产品思维导图基于SimpleMindMap项目开发，版权归源项目所有，[开源协议](https://github.com/wanglin2/mind-map/blob/main/LICENSE)。

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

微信添加`wanglinguanfang`拉你入群。根据过往的经验，大部分问题都可以通过查看issue列表或文档解决，所以提问前请确保你已经阅读完了所有文档，文档里没有的可在群里提问，不必私聊作者，如果你一定要私聊，请先赞助本项目（￥200+）。

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="http://drawon.cn/">
                <img src="./web/src/assets/img/gzh.jpeg" width="100;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>微信公众号</b></sub>
            </a>
        </td>
    </tr>
</table>

![Image](https://github.com/user-attachments/assets/a27ed620-30a3-460d-85b2-6fa869a91780)


[![Star History Chart](https://api.star-history.com/svg?repos=wanglin2/mind-map&type=Date)](https://star-history.com/#wanglin2/mind-map&Date)

# 关于定制

如果你有个性化的商用定制需求，可以联系我们，我们提供付费开发服务，无论前端、后端、还是部署，都可以帮你一站式搞定。

# 谁在使用

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="http://drawon.cn/">
                <img src="./web/src/assets/avatar/桌案.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>drawon.cn(桌案)</b></sub>
            </a>
        </td>
    </tr>
</table>

# 请作者喝杯咖啡

开源不易，如果本项目有帮助到你的话，可以考虑请作者喝杯咖啡~你的赞助对项目的可持续发展非常重要，是作者持续维护的最大动力。

> 推荐使用支付宝，微信获取不到头像。转账请备注【思维导图赞助】。

> 赞助等级：最强王者（￥500+）、星耀赞助（￥300+）、钻石赞助（￥200+）、黄金赞助（￥100+）、青铜赞助

<p>
  <img src="./web/src/assets/img/alipay.jpg" style="width: 300px" />
  <img src="./web/src/assets/img/wechat.jpg" style="width: 300px" />
</p>

## 最强王者

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/hi.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>hi</b></sub>
            </a>
        </td>
    </tr>
</table>

## 钻石赞助

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/黄智彪@一米一栗科技.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>黄智彪@一米一栗科技</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/沨沄.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>沨沄</b></sub>
            </a>
        </td>
    </tr>
</table>

## 黄金赞助

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/小土渣的宇宙.jpeg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>小土渣的宇宙</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Chris.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Chris</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/仓鼠.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>仓鼠</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/风格.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>风格</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>LiuJL</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Kyle.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Kyle</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/秀树因馨雨.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>秀树因馨雨</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>黄泳</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/ccccs.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>ccccs</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/炫.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>炫</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>晏江</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/梁辉.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>梁辉</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/千帆.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>千帆</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/布林.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>布林</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/达仁科技.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>达仁科技</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/沐风牧草.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>沐风牧草</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/俊奇.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>俊奇</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/庆国.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>庆国</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Matt</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/雨馨.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>雨馨</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/峰.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>峰</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/御风.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>御风</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/兔子快跑.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>兔子快跑</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>LSHM</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>newplayer</b></sub>
            </a>
        </td>
    </tr>
</table>

## 青铜赞助

<table>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Think.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Think</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/志斌.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>志斌</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/qp.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>qp</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/ZXR.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>ZXR</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/花儿朵朵.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>花儿朵朵</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/suka.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>suka</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/水车.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>水车</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/才镇.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>才镇</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/小米.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>小米bbᯤ²ᴳ</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/棐.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>*棐</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/南风.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>南风</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/蜉蝣撼大叔.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>蜉蝣撼大叔</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/乙.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>乙</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/敏.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>敏</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/有希.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>有希</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/樊笼.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>樊笼</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/小逗比.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>小逗比</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/天清如愿.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>天清如愿</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/敬明朗.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>敬明朗</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>飞箭</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/戚永峰.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>戚永峰</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/moom.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>moom</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/张扬.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>张扬</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/长沙利奥软件.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>长沙利奥软件</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/HaHN.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>HaHN</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/继龙.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>继龙</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/欣.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>欣</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>易空小易</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/国发.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>国发</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>建明</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/汪津合.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>汪津合</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>博文</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/慕智打印-兰兰.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>慕智打印-兰兰</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>锦冰</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/旭东.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>旭东</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/橘半.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>橘半</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/pluvet.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>pluvet</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/皇登攀.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>皇登攀</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>SR</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/逆水行舟.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>逆水行舟</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/L.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>L</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>sunniberg</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/在下青铜五.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>sunniberg</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/在下青铜五.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>在下青铜五</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/木星二号.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>木星二号</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/阿晨.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>阿晨</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>铁</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Alex.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Alex</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/子豪.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>子豪</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/宏涛.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>宏涛</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/最多5个字.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>最多5个字</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/ZX.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>ZX</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>协成</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/木木.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>木木</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/好名字.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>好名字</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/lsytyrt.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>lsytyrt</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/buddy.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>buddy</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>小川</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Tobin.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Tobin</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/夏虫不语冰.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>夏虫不语冰</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/晴空.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>晴空</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/。.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>。</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Jeffrey.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Jeffrey</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/张文建.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>张文建</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Lawliet.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Lawliet</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/一叶孤舟.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>一叶孤舟</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Eric</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Joe.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Joe</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>中文网字计划-江夏尧</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/海云.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>海云</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/皮老板.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>皮老板</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/h.r.w.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>h.r.w</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/时光匆匆.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>时光匆匆</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/广兴.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>广兴</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/一亩三.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>一亩三</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/xbkkjbs0246658.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>xbkkjbs0246658</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/4399行星元帅.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>4399行星元帅</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Xavier.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Xavier</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/冒号括号.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>:)</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/可米阳光.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>可米阳光</b></sub>
            </a>
        </td>
    </tr>
    <tr>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/MrFujing.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>MrFujing</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/Sword.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Sword</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/好好先生Ervin.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>好好先生Ervin</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/胡永刚.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>胡永刚</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/旋风.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>旋风</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/星夜寒.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>星夜寒</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/神话.jpg" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>神话</b></sub>
            </a>
        </td>
        <td align="center" style="word-wrap: break-word; width: 75.0; height: 75.0">
            <a href="#">
                <img src="./web/src/assets/avatar/default.png" width="50;"  style="border-radius:50%;align-items:center;justify-content:center;overflow:hidden;padding-top:10px"/>
                <br />
                <sub style="font-size:14px"><b>Towards the future</b></sub>
            </a>
        </td>
    </tr>
</table>