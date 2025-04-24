单平台 Docker 镜像构建指南：Mind-Map

### 获取代码

```Bash
# 克隆仓库
git clone https://github.com/Hraulein/mind-map.git

# 进入项目目录
cd mind-map

# 切换到 docker 分支
git checkout docker
```

### 构建 Docker 镜像

```Bash
# 执行构建
version="v0.1.0"
docker build -t single-mind-map:${version} -f ./docker/single-platform/Dockerfile .
```

参数说明：

* `-t single-mind-map:${version}`：指定镜像名称和标签
* `.`：使用当前目录作为构建上下文

### 运行容器

```Bash
# 基础运行（后台模式）
docker run -d -p 8080:8080 --name snigle-mind-map single-mind-map:v0.1.0

# 调试运行（前台模式，查看日志）
docker run -p 8080:8080 --rm single-mind-map:v0.1.0
```

端口映射：

* `8080:8080`：将容器内 `8080` 端口映射到主机 `8080` 端口

### 验证服务

访问应用：

    http://localhost:8080

或通过命令行测试：

```Bash
curl http://localhost:8080
```
