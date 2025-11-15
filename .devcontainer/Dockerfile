FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
ARG TF_VERSION=1.9.8
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip -o /tmp/tf.zip \
 && unzip /tmp/tf.zip -d /usr/local/bin && rm /tmp/tf.zip
RUN apt-get update && apt-get install -y powershell jq git make unzip
