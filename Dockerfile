FROM ubuntu:latest

RUN apt-get update \
    && apt-get install -y locales \
        curl \
        wget \
        git \
        tmux \
        procps \
        sudo \
        zsh \
        fzf \
        man-db \
        unzip \
        gnupg2 \
        gh \
        iptables \
        ipset \
        iproute2 \
        dnsutils \
        aggregate \
        jq \
        nano \
        vim \
        rsync \
        build-essential cmake \
        make \
        ffmpeg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu

ENV LANG en_US.utf8

WORKDIR /home/ubuntu/workspace

RUN mkdir -p ~/miniconda3 \
    && wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh \
    && bash /home/ubuntu/miniconda3/miniconda.sh -b -u -p /home/ubuntu/miniconda3 \
    && rm /home/ubuntu/miniconda3/miniconda.sh \
    && /home/ubuntu/miniconda3/bin/conda init zsh \
    && . /home/ubuntu/miniconda3/bin/activate \
    && pip install uv

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash \
    && export NVM_DIR="/home/ubuntu/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install --lts \
    && nvm use --lts \
    && npm install -g excel-csv-mcp-server \
    && npm install -g @playwright/mcp@latest \
    && npx playwright install chrome \
    && npm install -g @benborla29/mcp-server-mysql \
    && npm install -g @modelcontextprotocol/server-filesystem

RUN curl -fsSL https://claude.ai/install.sh | bash

RUN sh -c "$(curl -fsSL https://install.ohmyz.sh)" \
    && echo '. $HOME/miniconda3/bin/activate' >> ~/.zshrc \
    && echo '. $HOME/miniconda3/bin/activate' >> ~/.bashrc \
    && echo '. $HOME/.nvm/nvm.sh' >> ~/.zshrc \
    && echo '. $HOME/.nvm/nvm.sh' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
