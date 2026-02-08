# 新的项目只需要修改这一行就可以
MODULE_NAME :=github.com/daheige/hello-pb

# 下面的内容不需要更改
IMAGE_NAME :=$(shell basename $(MODULE_NAME))
CONTAINER_NAME :=${IMAGE_NAME}-svc

VERSION :=v1.0
DEV_IMAGE_NAME :=grpc-dev
ROOT_DIR=$(shell pwd)
DEV_IMAGE_SHA := $(shell docker images -q ${DEV_IMAGE_NAME}:${VERSION})

# 开发环境镜像构建
build-dev:
	@if [ "${DEV_IMAGE_SHA}" ]; then \
        echo "current ${DEV_IMAGE_NAME}:${VERSION} image sha: ${DEV_IMAGE_SHA}";\
    else \
        docker build . -f Dockerfile-dev -t ${DEV_IMAGE_NAME}:${VERSION};\
    fi

# 重新构建grpc-dev 开发环境镜像
rebuild-dev:
	docker build . -f Dockerfile-dev -t ${DEV_IMAGE_NAME}:${VERSION}

# 构建 grpc pb gen 容器镜像
build: build-dev
	@echo "rebuild ${DEV_IMAGE_NAME}:${VERSION} image"
	docker build . -t ${IMAGE_NAME}:${VERSION} -f Dockerfile

# 运行 grpc pb code gen 容器
run:
	docker run -itd --name ${CONTAINER_NAME} -v ${ROOT_DIR}/bin:/app/bin -v ${ROOT_DIR}/pb:/app/pb \
	-v ${ROOT_DIR}/protos:/app/protos -v ${ROOT_DIR}/nodejs:/app/nodejs \
	-v ${ROOT_DIR}/src:/app/src -v ${ROOT_DIR}/go.mod:/app/go.mod \
	-v ${ROOT_DIR}/go.sum:/app/go.sum ${IMAGE_NAME}:${VERSION} /bin/bash

# 进入 grpc pb code gen 容器
exec:
	docker exec -it ${CONTAINER_NAME} /bin/bash

rerun: remove run

rebuild-run: build rerun

pb-rebuild-run: build rerun exec

stop:
	docker stop ${CONTAINER_NAME}

restart:
	docker restart ${CONTAINER_NAME}

remove:
	docker rm -f ${CONTAINER_NAME}

# 初始化go.mod
go-mod-init:
	@if [ ! -f ${ROOT_DIR}/go.mod ];then \
		go mod init ${MODULE_NAME};\
	fi

# 一键生成pb代码
gen: go-mod-init gen-pb gen-node gen-rust
	@echo "gen pb success"

gen-pb:
	sh bin/go-generate.sh
	go mod tidy

gen-node:
	sh bin/nodejs-gen.sh

gen-rust:
	@echo "gen rust pb code"
	@cargo build
	@cargo fmt
	@echo "gen rust pb code success"
