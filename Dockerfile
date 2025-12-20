FROM grpc-dev:v1.0 AS builder

LABEL authors="daheige"

# 设置环境变量
ENV LANG=C.UTF-8

WORKDIR /app

COPY . .

# 设置默认命令
CMD ["bash"]
