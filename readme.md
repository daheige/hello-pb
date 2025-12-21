# grpc pb code gen
一般来说，生成的pb代码，建议放在独立git仓库中，方便集中式管理和维护，例如：https://github.com/daheige/hello-pb

# tools installation before development
1. 进入 https://go.dev/dl/ 官方网站，根据系统安装不同的go版本，这里推荐在linux或mac系统上面安装go。
2. 设置GOPROXY
```shell
go env -w GOPROXY=https://goproxy.cn,direct
```
3. 安装protoc工具
- mac系统安装方式如下：
```shell
brew install protobuf
```
- linux系统安装方式如下：
```shell
# Reference: https://grpc.io/docs/protoc-installation/
PB_REL="https://github.com/protocolbuffers/protobuf/releases"
curl -LO $PB_REL/download/v3.15.8/protoc-3.15.8-linux-x86_64.zip
unzip -o protoc-3.15.8-linux-x86_64.zip -d $HOME/.local
export PATH=~/.local/bin:$PATH # Add this to your `~/.bashrc`.
protoc --version
libprotoc 3.15.8
```

# gen pb code
1. 先执行如下命令安装必要的go tools
```shell
sh bin/grpc_tools.sh
# 如果本机安装了nodejs，可以执行如下命令，安装nodejs grpc 工具链
sh bin/node-grpc-tools.sh
```

2. 执行如下命令实现go代码生成
```shell
sh bin/go-generate.sh
```
或者直接执行`make gen`生成Go/nodejs/rust对应的pb代码(需要提前安装好rust)

# gen pb code in docker
```shell
make build-dev
make build && make run
# 进入容器中执行如下命令，一键生成Go/nodejs/rust对应的pb代码
make gen
```
