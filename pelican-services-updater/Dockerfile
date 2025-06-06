# TODO:
# Set fixed versions for every package and add comms about flags

FROM ubuntu:24.04

# install curl
# -y - run in non-interactive mode
RUN apt-get update && apt-get install curl -y


# install kind https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
# curl -Lo - follow redirects and write to file
RUN [ $(uname -m) = x86_64 ] && curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64 && \
    chmod +x /usr/local/bin/kind

# install git
# -y - run in non-interactive mode
RUN apt-get install git -y

# install helm https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
# curl -o - write to file
# chmod +x - make file executable
RUN curl -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get_helm.sh && \
    ./get_helm.sh

# install helm-diff plugin
RUN helm plugin install https://github.com/databus23/helm-diff --version=3.9.6

# install helm-git plugin
RUN helm plugin install https://github.com/aslafy-z/helm-git --version 1.3.0

# install helmfile https://github.com/schlich/devcontainer-features/blob/main/src/helmfile/install.sh
# curl -L - follow redirects
# chmod +x - make file executable
RUN curl -L https://github.com/helmfile/helmfile/releases/download/v0.157.0/helmfile_0.157.0_linux_amd64.tar.gz | tar xz && \
    chmod +x helmfile && \
    mv helmfile /usr/local/bin

# install kubectl https://stackoverflow.com/a/68674384
COPY --from=bitnami/kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/kubectl

# Clone local env and apply helmfile
CMD git clone https://github.com/TourmalineCore/pelican-local-env.git && \
    helmfile cache cleanup && helmfile --environment local --namespace local -f pelican-local-env/deploy/helmfile.yaml apply