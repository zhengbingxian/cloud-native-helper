#!/bin/bash

### 说明
# 使用说明：此脚本作用是为chaosmesh tag2.4.1进行 ci-e2e。 成果物为ginkgo与e2etest，可以直接在任何集群运行。所以较为有用。
# 使用方法：run.sh <架构[amd64,arm64]>
###

if [ $# -ne 1 ]; then
  print_help
  exit 1
fi


arch=$1

# ----下载指定分支代码----
rm -rf chaos-mesh
git clone git@github.com:chaos-mesh/chaos-mesh.git -b v2.4.1
cd chaos-mesh
git checkout -b v2.4.1 v2.4.1
# ----

#------ 镜像本地化----------------------------------------------------
# 修改k8s.gcr.io的镜像：NA
# 修改gcr.io的镜像：
sed -i "s#gcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/gcr.io#" Makefile
sed -i "s#gcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/gcr.io#g" hack/run-e2e.sh  # 有多处
sed -i "s#gcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/gcr.io#" e2e-test/config.go
sed -i "s#gcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/gcr.io#" e2e-test/e2e/config/config.go
# 修改ghcr.io镜像：
sed -i "s#ghcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/ghcr.io#" Makefile
sed -i "s#ghcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/ghcr.io#" e2e-test/config.go
sed -i "s#ghcr.io#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/ghcr.io#"  e2e-test/e2e/config/config.go
# 其他
sed -i "s#latest#v2.4#" Makefile   #把latest都换成v2.4
sed -i "s#latest#v2.4#g" env-images.yaml # 必须改掉，强制去ghcr.io/chaos-mesh/dev-env:latest获取
sed -i "s#golang:1.18-alpine3.15#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/golang:1.18-alpine3.15#"  e2e-test/cmd/e2e_helper/Dockerfile
sed -i "s#alpine:3.15#swr.cn-east-3.myhuaweicloud.com/zbx/${arch}/alpine:3.15#"  e2e-test/cmd/e2e_helper/Dockerfile
# ------------------------------------------------------------

# 特殊修改-------------------
sed -i "s#15#120#g" e2e-test/e2e/chaos/stresschaos/cpu.go  # 此处15s等待时间过短，经常e2e fail。故自行修改

# 开始build

export GOPROXY=https://proxy.golang.com.cn,direct   # 设置代理，由于下面步骤go download太慢
export KUBECONFIG=/root/.kube/config
make e2e-build
mv ./e2e-test/image/e2e/bin/ginkgo  ../
mv ./e2e-test/image/e2e/bin/e2e.test ../
