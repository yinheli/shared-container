FROM debian:bookworm

RUN sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && \
    apt-get install -y nfs-kernel-server samba && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY boot.sh /boot.sh

CMD ["/boot.sh"]
