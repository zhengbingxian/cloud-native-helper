#!/bin/bash

### 说明
# 使用说明：就把run-ci-e2e.sh生成的ginkgo和e2etest拷贝过去即可。
###

# 全部
export KUBECONFIG=/root/.kube/config && ./ginkgo ./e2e.test -- --e2e-image swr.cn-east-3.myhuaweicloud.com/zbx/amd64/e2e-helper:v2.4

# focus指定demo
# export KUBECONFIG=/root/.kube/config && ./ginkgo -focus="PodChaos" ./e2e.test -- --e2e-image swr.cn-east-3.myhuaweicloud.com/zbx/amd64/e2e-helper:v2.4
# export KUBECONFIG=/root/.kube/config && ./ginkgo -focus="\[PodChaos\].*PodFailure.*Pause" ./e2e.test -- --e2e-image swr.cn-east-3.myhuaweicloud.com/zbx/amd64/e2e-helper:v2.4
# export KUBECONFIG=/root/.kube/config && ./ginkgo -focus="StressChaos.*CPU" ./e2e.test -- --e2e-image swr.cn-east-3.myhuaweicloud.com/zbx/amd64/e2e-helper:v2.4