# 构建阶段
FROM --platform=$BUILDPLATFORM golang:1.23.8-alpine AS builder
ARG TARGETARCH TARGETVARIANT   

WORKDIR /go/src
COPY docker/src/ /go/src
RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux GOARCH=$TARGETARCH GOARM=${TARGETVARIANT#v} \
    go build -ldflags="-s -w" -o /httpdGIN cmd/httpd/main.go    

RUN apk add --no-cache upx && \
    upx --best /httpdGIN

# 运行阶段 #
# FROM alpine:3.21

FROM scratch

# 复制二进制和静态资源
COPY --from=builder /httpdGIN /httpdGIN
COPY --from=builder /go/src/conf.d/ /conf.d/
COPY dist/ /app/dist/
COPY index.html /app/

# 定义用户以及赋权 #
# RUN adduser -D -u 1000 httpd && \
#     chown -R httpd:httpd /app /httpdGIN /conf.d
# USER httpd

EXPOSE 8080
CMD ["/httpdGIN"]