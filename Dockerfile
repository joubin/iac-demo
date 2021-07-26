FROM ubuntu

ENV TZ=America/Los_Angles
ENV DEBIAN_FRONTEND="noninteractive"
WORKDIR /app

RUN DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt install -y \
    gnupg \
    software-properties-common \
    curl \
    python3 \
    pip \
    git \
    tzdata \
    iputils-ping \
    unzip && \
    pip install terraform-compliance[faster_parsing] && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg |  apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    DEBIAN_FRONTEND="noninteractive" apt update && \
    DEBIAN_FRONTEND="noninteractive" apt install terraform && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws awscliv2.zip && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash app

ENV FEATURE-FILES="git:https://github.com/terraform-compliance/user-friendly-features/tree/master/aws?ref=master"
ENV AWS_ACCESS_KEY_ID=test
ENV AWS_SECRET_ACCESS_KEY=test



