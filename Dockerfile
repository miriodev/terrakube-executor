FROM azbuilder/executor:2.27.2

ENV TOOLS_ARCH="arm64"
ENV OPENTOFU_VERSION="1.10.6"
ENV TERRAFORM_VERSION="1.13.3"
ENV TERRAGRUNT_VERSION="0.88.1"
ENV SOPS_VERSION="3.11.0"
ENV AGE_VERSION="1.2.1"

USER 0
RUN apt update && apt -y upgrade && apt install -y gpg gpg-agent wget zip && mkdir /tmp/todelete && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install utilities
WORKDIR /tmp/todelete
## Install OPENTOFU
RUN wget "https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VERSION}/tofu_${OPENTOFU_VERSION}_linux_${TOOLS_ARCH}.zip" -O opentofu.zip -q && unzip opentofu.zip && mv tofu /usr/local/bin/tofu
## Install Terraform
RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TOOLS_ARCH}.zip" -O terraform.zip -q && unzip terraform.zip && mv terraform /usr/local/bin/terraform
## Install Sops
RUN wget "https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.${TOOLS_ARCH}" -O sops -q && chmod +x sops && mv sops /usr/local/bin/sops
## Install Age
RUN wget "https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-${TOOLS_ARCH}.tar.gz" -O age.tar.gz -q && tar xfz age.tar.gz && mv age/age /usr/local/bin/age && mv age/age-keygen /usr/local/bin/age-keygen 
## Install Terragrunt
RUN wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_arm64" -O terragrunt -q && chmod +x terragrunt && mv terragrunt /usr/local/bin/terragrunt
## Cleanup
RUN rm -rf /tmp/todelete

USER 1002:1000

WORKDIR /workspace
