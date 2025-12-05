FROM --platform=$BUILDPLATFORM registry.cn-hangzhou.aliyuncs.com/jingansi/golang:1.25.4 AS builder
# ARG 的声明周期到下一个 FROM 为止
ARG TARGETOS
ARG TARGETARCH

# GO 环境变量设置
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    CGO_ENABLED=0 \
    GIN_MODE=release

WORKDIR /build

# 将代码复制到容器中
COPY . .

# 下载依赖并编译
RUN go mod download
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o jenkins_demo .

# 构建小镜像 （已经自带时区文件）
FROM registry.cn-hangzhou.aliyuncs.com/jingansi/alpine:3.20.3

# 从builder镜像中把/dist/app 拷贝到当前目录
COPY --from=builder /build/jenkins_demo /

ENV TZ=Asia/Shanghai \
    GIN_MODE=release

# 拷贝配置文件
# COPY ./config /config

EXPOSE 8080

# 需要运行的命令
ENTRYPOINT [ "/jenkins_demo" ]