FROM azbuilder/executor:2.33.2

ARG TARGETARCH

ENV OPENTOFU_VERSION="1.13.1"
ENV TERRAFORM_VERSION="1.16.5"
ENV TERRAGRUNT_VERSION="1.1.6"
ENV SOPS_VERSION="3.13.3"
ENV AGE_VERSION="1.3.2"

USER 0
RUN apt update && apt -y upgrade && apt install -y gpg gpg-agent wget zip && mkdir /tmp/todelete && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY inject_terragrunt.bash /usr/local/bin/inject_terragrunt.bash

# Install utilities
WORKDIR /tmp/todelete
## Install OPENTOFU
RUN wget "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_${TARGETARCH}.zip" -O opentofu.zip -q && unzip opentofu.zip && mv tofu /usr/local/bin/tofu \
    && wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" -O terraform.zip -q && unzip terraform.zip && mv terraform /usr/local/bin/terraform \
    && wget "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.${TARGETARCH}" -O sops -q && chmod +x sops && mv sops /usr/local/bin/sops \
    && wget "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-${TARGETARCH}.tar.gz" -O age.tar.gz -q && tar xfz age.tar.gz && mv age/age /usr/local/bin/age && mv age/age-keygen /usr/local/bin/age-keygen \
    && wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH}" -O terragrunt -q && chmod +x terragrunt && mv terragrunt /usr/local/bin/terragrunt \
    && rm -rf /tmp/todelete && chmod +x /usr/local/bin/inject_terragrunt.bash

USER 1002:1000
ENV HOME="/home/cnb"

WORKDIR /workspace
