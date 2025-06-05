FROM ubuntu:24.04

# install curl
RUN apt-get update && apt-get install curl -y

# install git
RUN apt-get install git -y

# install kind
RUN [ $(uname -m) = x86_64 ] && curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64 && chmod +x /usr/local/bin/kind

# install helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# install helm-diff plugin
RUN helm plugin install https://github.com/databus23/helm-diff --version=3.9.6

# install helm-git plugin
RUN helm plugin install https://github.com/aslafy-z/helm-git --version 1.3.0

# install helmfile
RUN curl -L https://github.com/helmfile/helmfile/releases/download/v0.157.0/helmfile_0.157.0_linux_amd64.tar.gz | tar xz && \
    chmod +x helmfile && \
    mv helmfile /usr/local/bin

# install kubectl
COPY --from=bitnami/kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/kubectl

# RUN git clone https://github.com/TourmalineCore/pelican-local-env.git

# CMD sleep 120000

CMD git clone https://github.com/TourmalineCore/pelican-local-env.git && \
    helmfile cache cleanup && helmfile --environment local --namespace local -f pelican-local-env/deploy/helmfile.yaml apply
 

# WORKDIR /app

# COPY services-updater.py .

# RUN apt-get update && \
#     apt-get install -y ca-certificates curl && \
#     install -m 0755 -d /etc/apt/keyrings && \
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
#     chmod a+r /etc/apt/keyrings/docker.asc && \
#     echo \
#       "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#       $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#       tee /etc/apt/sources.list.d/docker.list > /dev/null && \
#     apt-get update && \
#     apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# RUN apt install net-tools

# RUN apk update && apk add bash curl

# ENV NVM_DIR /usr/local/nvm
# ENV NODE_VERSION v23.6.0
# RUN mkdir -p /usr/local/nvm
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"
# ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/bin
# ENV PATH $NODE_PATH:$PATH

# CMD sleep 1200000

# CMD docker ps

# CMD devcontainer up --workspace-folder . --log-level trace

# Simple solution how to up docker daemon: https://forums.docker.com/t/docker-in-docker-not-running-when-using-official-docker-dind-image/111891/8
# docker run -d -p 22:22 -v /var/run/docker.sock:/var/run/docker.sock pelican-services-updater:0.0.1

# to access cluster inside of devcontainer change cluster url in .pelican-cluster-kubeconfig to internal https://pelican-control-plane:6443