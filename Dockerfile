ARG DOCKERHUB_PROXY
FROM ${DOCKERHUB_PROXY}library/ubuntu:jammy

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Configure local ubuntu mirror as package source
COPY sources.list /etc/apt/sources.list

RUN \
  ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    build-essential \
    libbpf-dev \
    libbsd-dev \
    libnuma-dev \
    libpcap-dev \
    libssl-dev \
    locales \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    python3-pyelftools \
    python3-requests \
    python3-setuptools \
    python3-wheel \
    wget \
    zlib1g-dev \
    && \
  pip3 install \
    meson \
    && \
  apt-get autoclean && \
  apt-get autoremove && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8 && \
  rm -rf /var/lib/apt/lists/*

COPY xilinx-qdma-for-opennic/QDMA/DPDK /QDMA/DPDK
COPY patches /patches

# Download build and install DPDK
ARG DPDK_BASE_URL="https://fast.dpdk.org/rel"
ARG DPDK_VER="22.11.2"
#ARG DPDK_TOPDIR="dpdk-${DPDK_VER}"
ARG DPDK_TOPDIR="dpdk-stable-${DPDK_VER}"
RUN \
  wget -q $DPDK_BASE_URL/dpdk-$DPDK_VER.tar.xz && \
    tar xf dpdk-$DPDK_VER.tar.xz && \
    rm dpdk-$DPDK_VER.tar.xz && \
    cd $DPDK_TOPDIR && \
    ln -s /QDMA/DPDK/drivers/net/qdma ./drivers/net && \
    patch -p 1 < /patches/0000-dpdk-include-xilinx-qdma-driver.patch && \
    meson setup build -Denable_drivers=net/af_packet,net/pcap,net/qdma,net/ring,net/tap,net/virtio && \
    cd build && \
    ninja && \
    ninja install && \
    ldconfig && \
    cd ../../ && \
    rm -r $DPDK_TOPDIR

# Build and install pktgen-dpdk
RUN \
  ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    liblua5.3-dev \
    make \
    && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

ARG PKTGEN_BASE_URL="https://github.com/pktgen/Pktgen-DPDK/archive/refs/tags"
ARG PKTGEN_VER=23.03.0
ARG PKTGEN_TOPDIR="Pktgen-DPDK-pktgen-${PKTGEN_VER}"
RUN \
  wget -q $PKTGEN_BASE_URL/pktgen-$PKTGEN_VER.tar.gz && \
    tar xaf pktgen-$PKTGEN_VER.tar.gz && \
    rm pktgen-$PKTGEN_VER.tar.gz && \
    cd $PKTGEN_TOPDIR && \
    export PKTGEN_DESTDIR=/ && \
    make buildlua && \
    make install && \
    cd .. && \
    rm -r $PKTGEN_TOPDIR

# Install some useful tools to have inside of this container
RUN \
  ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
    iproute2 \
    jq \
    lsb-release \
    pciutils \
    python3-scapy \
    tcpreplay \
    tshark \
    unzip \
    vim-tiny \
    zstd \
    && \
  pip3 install \
    yq \
    && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "-l"]
