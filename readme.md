# grpc pb code gen
- 一般来说，生成的pb代码，建议放在独立git仓库中，方便集中式管理和维护，例如：https://github.com/daheige/hello-pb
- 微服务具体使用方式见：https://github.com/daheige/hephfx-micro-svc

# tools installation before development
1. 进入 https://go.dev/dl/ 官方网站，根据系统安装不同的go版本，这里推荐在linux或mac系统上面安装go。
2. 设置Go GOPROXY 环境变量
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
4. 执行如下命令安装rust
```shell
# 下面两个环境变量，建议放在 ~/.bash_profile 或 ~/.bashrc 文件中
# 然后执行 source ~/.bash_profile 或 source ~/.bashrc 生效
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
这里也可以使用rsproxy代理(建议跟`~/.cargo/config.toml`文件中的`replace-with`配置保持一致)，这里我使用的是`ustc`镜像源
```shell
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
```

通过 vim ~/.cargo/config.toml 文件添加如下内容：
```toml
[source.crates-io]
#registry = "https://github.com/rust-lang/crates.io-index"
# 指定镜像，这里可以根据实际情况选择不同的镜像
replace-with = 'ustc'

# 字节跳动的rsproxy，指定方式，只需要调整 [source.crates-io] 下面的 `replace-with = 'rsproxy-sparse'` 或 `replace-with = 'rsproxy'`
[source.rsproxy]
registry = "https://rsproxy.cn/crates.io-index"
[source.rsproxy-sparse]
registry = "sparse+https://rsproxy.cn/index/"

[registries.rsproxy]
index = "https://rsproxy.cn/crates.io-index"

# 清华大学
[source.tuna]
registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"

# 中国科学技术大学
[source.ustc]
registry = "sparse+https://mirrors.ustc.edu.cn/crates.io-index/"

# 上海交通大学
[source.sjtu]
registry = "https://mirrors.sjtug.sjtu.edu.cn/git/crates.io-index"

# rustcc社区
[source.rustcc]
registry = "git://crates.rustcc.cn/crates.io-index"

# xuanwu社区，指定方式，只需要调整 [source.crates-io] 下面的 `replace-with = 'xuanwu-sparse'` 即可
[source.xuanwu]
registry = "https://mirror.xuanwu.openatom.cn/crates.io-index"
[source.xuanwu-sparse]
registry = "sparse+https://mirror.xuanwu.openatom.cn/index/"
[registries.xuanwu]
index = "https://mirror.xuanwu.openatom.cn/crates.io-index"

[net]
git-fetch-with-cli=true
[http]
check-revoke = false
```

5. 根据操作系统类型，在 https://nodejs.org/zh-cn/download 下载并安装nodejs

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
执行如下命令，构建pb docker镜像和容器运行
```shell
make build-dev
make build && make run
# 进入容器中执行如下命令，一键生成Go/nodejs/rust对应的pb代码
make gen
```
