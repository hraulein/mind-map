# 构建阶段 #
FROM golang:1.23.8-alpine AS builder
WORKDIR /go/src
COPY docker/src/ /go/src 
RUN go mod download
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /httpdGIN cmd/httpd/main.go
RUN apk add --no-cache upx && \
    upx --best /httpdGIN


# 运行阶段 #
FROM alpine:3.21
# 相比 alpine:3.21 节省 7.83MB 镜像体积, 但会导致无法进入镜像(不影响运行)
# FROM scratch 

## 复制二进制和静态资源
COPY --from=builder /httpdGIN /httpdGIN
COPY --from=builder /go/src/conf.d/config.yaml /conf.d/
COPY dist/ /app/dist/
COPY index.html /app/

## 如果不使用 httpd 用户可节省 15.8MB 镜像体积
## 权限设置
# RUN adduser -D -u 1000 httpd && \
#     chown -R httpd:httpd /app /httpdGIN /conf.d
## 使用 httpd 用户运行
# USER httpd

EXPOSE 8080
CMD ["/httpdGIN"]