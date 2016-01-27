# Reference:
#   https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/install/installation.md

FROM test/base:1.0.0 

# Install build dependencies, kerberos excluded
RUN apt-get update \
 && apt-get install -y \
    sudo \
    build-essential \
    zlib1g-dev \
    libyaml-dev \
    libssl-dev \
    libgdbm-dev \
    libreadline-dev \
    libncurses5-dev \
    libffi-dev \
    libpq-dev \
    curl \
    openssh-server \
    checkinstall \
    libxml2-dev \
    libxslt-dev \
    libcurl4-openssl-dev \
    libicu-dev logrotate \
    python-docutils \
    pkg-config \
    cmake \
    nodejs \
    git-core

# Compile and install ruby 2.1.7 and install the ruby bundler gem. An older ruby 1.8 will be removed
RUN apt-get remove ruby1.8 \
 && mkdir /tmp/ruby && cd /tmp/ruby \
 && curl -O --progress https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.7.tar.gz \
 && echo 'e2e195a4a58133e3ad33b955c829bb536fa3c075  ruby-2.1.7.tar.gz' | shasum -c - && tar xzf ruby-2.1.7.tar.gz \
 && cd ruby-2.1.7 \
 && ./configure --disable-install-rdoc \
 && make \
 && make install \
 && gem install bundler --no-ri --no-rdoc \
 && rm -r /tmp/ruby

# Install golang
#   http://dave.cheney.net/unofficial-arm-tarballs
RUN curl -O --progress http://dave.cheney.net/paste/go1.5.3.linux-arm.tar.gz \
 && echo '91351355746af99659366d12dc85de11e8d14522  go1.5.3.linux-arm.tar.gz' | shasum -c - \
 && tar -C /usr/local -xzf go1.5.3.linux-arm.tar.gz \
 && ln -sf /usr/local/go/bin/{go,godoc,gofmt} /usr/local/bin/ \
 && rm go1.5.3.linux-arm.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
