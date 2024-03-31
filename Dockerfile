FROM ubuntu:23.10
#FROM --platform=$BUILDPLATFORM ubuntu
#FROM --platform=$BUILDPLATFORM ubuntu:23.10

LABEL maintainer="@k33g_org"

ARG TARGETOS
ARG TARGETARCH

ARG GO_VERSION=${GO_VERSION}

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_COLLATE=C
ENV LC_CTYPE=en_US.UTF-8

ARG DEBIAN_FRONTEND=noninteractive

# Update the system and install necessary tools
RUN <<EOF
apt-get update 
apt-get install -y curl wget git build-essential xz-utils bat exa software-properties-common 
apt-get -y install hey
ln -s /usr/bin/batcat /usr/bin/bat

apt-get clean autoclean
apt-get autoremove --yes
rm -rf /var/lib/{apt,dpkg,cache,log}/
EOF

# ------------------------------------
# Install Go
# ------------------------------------
RUN <<EOF

wget https://golang.org/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz
tar -xvf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz
mv go /usr/local
rm go${GO_VERSION}.linux-${TARGETARCH}.tar.gz
EOF

# ------------------------------------
# Set Environment Variables for Go
# ------------------------------------
ENV GOROOT=/usr/local/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

RUN <<EOF
go version
go install -v golang.org/x/tools/gopls@latest
go install -v github.com/ramya-rao-a/go-outline@latest
go install -v github.com/stamblerre/gocode@v1.0.0
go install -v github.com/mgechev/revive@v1.3.2
EOF

# ------------------------------------
# Install OhMyBash
# ------------------------------------
RUN <<EOF
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
EOF

