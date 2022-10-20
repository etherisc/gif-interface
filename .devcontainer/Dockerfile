# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT=3-bullseye
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="16"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# install mcfly as root
RUN curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly 

USER vscode

# Shell customizations

# 1) Install and configure starship.rs prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
RUN echo "eval \"\$(starship init bash)\"" >> ~/.bashrc && echo "eval \"\$(starship init zsh)\"" >> ~/.zshrc
RUN mkdir -p /home/vscode/.config/
COPY .devcontainer/starship.toml /home/vscode/.config/starship.toml

# 2) install thefuck
RUN pip3 install thefuck --user \
    && echo 'eval "$(thefuck --alias)"' >> ~/.bashrc \
    && echo 'eval "$(thefuck --alias)"' >> ~/.zshrc

# 3) install mcfly config
RUN echo 'eval "$(mcfly init zsh)"' >> ~/.zshrc \
    && touch ~/.zsh_history


# Install brownie & other devtools

# COPY requirements.txt /tmp/pip-tmp/
RUN wget https://raw.githubusercontent.com/eth-brownie/brownie/master/requirements.txt -O /tmp/pip-requirements.txt 

RUN python3 -m pip install --user pipx \
    && python3 -m pipx ensurepath \
    && pipx install eth-brownie

# [Optional] Uncomment this line to install global node packages.
RUN npm install -g ganache solhint prettier prettier-plugin-solidity solhint-plugin-prettier

# download required solidity compiler
COPY .devcontainer/scripts/install_solidity.sh /tmp
RUN /tmp/install_solidity.sh

ARG VERSION_OPEN_ZEPPELIN=4.7.3
RUN wget -O /tmp/v${VERSION_OPEN_ZEPPELIN}.tar.gz https://github.com/OpenZeppelin/openzeppelin-contracts/archive/refs/tags/v${VERSION_OPEN_ZEPPELIN}.tar.gz 
RUN mkdir -p /home/vscode/.brownie/packages/OpenZeppelin \
    && cd /home/vscode/.brownie/packages/OpenZeppelin \
    && tar xvfz /tmp/v${VERSION_OPEN_ZEPPELIN}.tar.gz \
    && mv openzeppelin-contracts-${VERSION_OPEN_ZEPPELIN} openzeppelin-contracts@${VERSION_OPEN_ZEPPELIN} 

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

WORKDIR /workspace
