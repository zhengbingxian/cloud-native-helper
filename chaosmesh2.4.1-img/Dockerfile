FROM swr.cn-east-3.myhuaweicloud.com/zbx/arch/debian:stretch-slim

ENV HOME=/config

# Basic check it works.
#RUN apt-get update && apt-get -y install net-tools && apt-get -y install curl
# 暂时不用RUN chmod +x /usr/local/bin/kubectl && kubectl version --client

COPY binary-arch/ginkgo /usr/local/bin/
COPY binary-arch/e2e.test /usr/local/bin/
COPY ./run.sh ./run.sh

ENTRYPOINT ["./run.sh"]
