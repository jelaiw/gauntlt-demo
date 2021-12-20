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
# nmap
RUN apt-get install -y nmap

# Consider deleting /var/lib/apt/lists to reduce image size.
# See https://askubuntu.com/questions/179955/var-lib-apt-lists-is-huge.

ENTRYPOINT [ "/usr/local/bin/gauntlt" ]
