#!/bin/bash

# 说明：ci e2e. 只不过打包成了img
# 运行方法 ./run-ci-e2eimg-forsonobuoy.sh  <架构[amd64,arm64]>
# 无法单独运行，必须1、依赖run-ci-e2e.sh生成amd64或arm64的二进制文件2、将本文件夹的e2e、ginkgo拷贝到对应的binary内


if [ $# -ne 1 ]; then
  print_help
  exit 1
fi

arch=$1

sed -i "s#arch/#${arch}/#g" Dockerfile
docker build . -t   swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/chaose2e:2.4-v1
docker push swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/chaose2e:2.4-v1
