FROM node:24.1.0-alpine AS node

FROM docker:dind

# from https://stackoverflow.com/a/76132347
COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

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

RUN node -v

RUN npm install -g @devcontainers/cli

# COPY devcontainer.json /app/.devcontainer/
COPY devcontainer.json .devcontainer/
COPY .pelican-cluster-kubeconfig .
COPY .pelican-cluster-kubeconfig ./workspaces/

# CMD sleep 1200000

# CMD docker ps

# CMD devcontainer up --workspace-folder . --log-level trace

# Simple solution how to up docker daemon: https://forums.docker.com/t/docker-in-docker-not-running-when-using-official-docker-dind-image/111891/8
# docker run -d -p 22:22 -v /var/run/docker.sock:/var/run/docker.sock pelican-services-updater:0.0.1

# to access cluster inside of devcontainer change cluster url in .pelican-cluster-kubeconfig to internal https://pelican-control-plane:6443