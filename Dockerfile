FROM ubuntu:20.04
MAINTAINER jelai.wang@gmail.com

ARG DEBIAN_FRONTEND=noninteractive

# Install Ruby and other OS stuff.
RUN apt-get update && \
    apt-get install -y build-essential \
    bzip2 \
    ca-certificates \
    curl \
    gcc \
    git \
    libcurl4 \
    libcurl4-openssl-dev \
    wget \
    zlib1g-dev \
    libfontconfig \
    libxml2-dev \
    libxslt1-dev \
    make \
    python3-pip \
	# Fix sqlmap dependency problem from Wickett lab.
    python-is-python3 \ 
    ruby \
    ruby-dev \
    ruby-bundler

# Install Gauntlt.
# See https://rubygems.org/gems/gauntlt.
RUN gem install rake
RUN gem install ffi -v 1.9.18
RUN gem install gauntlt

# Install attack tools.
# nmap, dirb are available as Ubuntu standard packages.
RUN apt-get install -y nmap dirb

# arachni
WORKDIR /opt
COPY vendor/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz arachni-1.5.1-0.5.12-linux-x86_64.tar.gz
RUN tar zxf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
	ln -s /opt/arachni-1.5.1-0.5.12/bin/* /usr/local/bin

# log4j-scan
# Note, python deps are not installed to venv.
WORKDIR /opt
COPY vendor/log4j-scan-v1.0.1.tar.gz log4j-scan-v1.0.1.tar.gz
RUN tar zxf log4j-scan-v1.0.1.tar.gz && \
	pip install -r log4j-scan-1.0.1/requirements.txt

# Specify location for dirb wordlists.
ENV DIRB_WORDLISTS /usr/share/dirb/wordlists

# Consider deleting /var/lib/apt/lists to reduce image size.
# See https://askubuntu.com/questions/179955/var-lib-apt-lists-is-huge.

ENTRYPOINT [ "/usr/local/bin/gauntlt" ]
