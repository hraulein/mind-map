# 【Simple mind map】Docker 镜像构建指南

## 获取代码

```Bash
# 克隆仓库
git clone https://github.com/Hraulein/mind-map.git

# 进入项目目录
cd mind-map
```

## 构建 Docker 镜像

### 单平台构建

```Bash
# 定义构建参数
single_container="single-mind-map"         # 镜像名称
single_container_tag="v0.1.0"              # 镜像标签/版本
```

``` bash
# 开始构建
docker build -t ${single_container}:${single_container_tag} -f ./docker/single-platform/Dockerfile .
```

参数说明：

* `-t ${single_container}:${single_container_tag}`：指定镜像名称和标签
* `-f ./docker/single-platform/Dockerfile`: 指定 Dockerfile 路径
* `.`：使用当前目录作为构建上下文

### 多平台构建

#### 安装 QEMU

> 跨平台构建依赖 QEMU：如果宿主机是 amd64 架构, 通过 docker buildx 构建 arm64 镜像，需安装 QEMU

```bash
docker run --privileged --rm tonistiigi/binfmt --install all
```

#### 创建构建器(buildx)

> 首次进行多平台构建需创建 buildx 容器

```bash
docker buildx create --name multiarch --use
```

#### 登录 docker

``` bash
# web-based login
docker login

# 或使用密码登录
docker_user="hraulein"                  # docker 用户名
docker login -u ${docker_user}
```

> `web-based login` 登录成功的参考输出

    $ docker login -u hraulein
    USING WEB-BASED LOGIN
    To sign in with credentials on the command line, use 'docker login -u <username>'

    Your one-time device confirmation code is: VZPR-XMBJ # 打开下面一行的网址, 把登录代码粘贴进去
    Press ENTER to open your browser or submit your device code here: https://login.docker.com/activate

    Waiting for authentication in the browser…
    WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credential-stores

    Login Succeeded # 登录成功信息


#### 执行多平台构建

> 将 `docker_user` 的值修改为你的 docker 用户名, 必须和刚才登录的用户一致

```bash
docker_user="hraulein"                      # docker 用户名
mulit_container="mulit-mind-map"            # 镜像名称
mulit_container_tag="v0.1.0"                # 镜像标签/版本
``` 

```bash
# 必须推送到 hub.docker.com 才能保留多架构
docker buildx build \
    --platform linux/amd64,linux/arm64,linux/arm/v7 \
    -t ${docker_user}/${mulit_container}:${mulit_container_tag} \
    --output=type=image,push=true \
    --no-cache \
    -f ./docker/multi-platform/Dockerfile .
```

#### 查看构建镜像的支持架构

```bash
docker manifest inspect ${docker_user}/${mulit_container}:${mulit_container_tag}
```

#### 验证构建的多平台可执行文件是否准确

```bash
# amd64 | x86-64
docker pull --platform linux/amd64 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker create --name tmp_mind-map_amd64 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker cp tmp_mind-map_amd64:/httpdGIN /tmp/httpdGIN-amd64
# arm64 | ARM aarch64
docker pull --platform linux/arm64 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker create --name tmp_mind-map_arm64 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker cp tmp_mind-map_arm64:/httpdGIN /tmp/httpdGIN-arm64
# arm/v7 | ARM 32-bit
docker pull --platform linux/arm/v7 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker create --name tmp_mind-map_armv7 ${docker_user}/${mulit_container}:${mulit_container_tag}
docker cp tmp_mind-map_armv7:/httpdGIN /tmp/httpdGIN-armv7

# 删除容器
docker ps -a |grep tmp_mind-map |awk '{print $1}' |xargs sudo docker rm

# 查看构建后的文件信息
file /tmp/httpdGIN-amd64 /tmp/httpdGIN-arm64 /tmp/httpdGIN-armv7

# 正确应输出 #
# httpdGIN-amd64: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, no section header
# httpdGIN-arm64: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, no section header
# httpdGIN-armv7: ELF 32-bit LSB executable, ARM, EABI5 version 1 (GNU/Linux), statically linked, no section header
```

## 运行容器

### 单平台镜像运行

```bash
docker run -d -p 8080:8080 --name single_mind-map ${single_container}:${single_container_tag}
```

### 多平台镜像运行

```Bash
docker run -d --name multi-mind-map -p 8080:8080 ${docker_user}/${mulit_container}:${mulit_container_tag}
```

端口映射：

* `8080:8080`：将容器内 `8080` 端口映射到主机 `8080` 端口

## 验证服务

访问应用：

    http://localhost:8080

或通过命令行测试：

```Bash
curl -vL http://localhost:8080
```
