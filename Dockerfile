FROM alpine:edge
LABEL maintainer="bat-cha <baptiste.chatrain@gmail.com>"

VOLUME ${HOME}/.aws
VOLUME /app
WORKDIR /app

RUN apk update && apk add --no-cache \
    bash \
    python3 \
    py3-pip \
    go \
    docker \
    git \
    openssl \
    openssh \
    terraform \
    jq \
    gettext \
    && pip3 install --upgrade awscli

# https://github.com/kubernetes/kops/releases
ENV KOPS_VERSION=1.9.0-alpha.1
# https://kubernetes.io/docs/tasks/kubectl/install/
# latest stable kubectl: curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt
ENV KUBECTL_VERSION=v1.9.4
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION=v2.8.2

RUN apk --no-cache add ca-certificates \
  && apk --no-cache add --virtual build-dependencies curl \
  && curl -O --location --silent --show-error https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64 \
  && mv kops-linux-amd64 /usr/local/bin/kops \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && mv kubectl /usr/local/bin/kubectl \
  && curl -LO https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz \
  && tar xvzf helm-${HELM_VERSION}-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/kops /usr/local/bin/kubectl /usr/local/bin/helm \
  && apk del --purge build-dependencies


