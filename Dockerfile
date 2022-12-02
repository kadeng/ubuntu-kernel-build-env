# Built it like this:
# docker build --build-arg USER --build-arg UID --build-arg UNAME=`uname -r` -t linux_build .

# run it like this:
# 
# docker run -v `pwd`:/build -v /boot:/boot -it linux_build
FROM ubuntu:22.04 AS base
ARG UNAME
ARG UID

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -ir 's/\# \?deb-src/deb-src/g' /etc/apt/sources.list

RUN apt-get update && apt upgrade -y && \
    apt-get update
RUN echo "#!/bin/bash\necho '$UNAME'" >/usr/bin/uname
RUN chmod +x /usr/bin/uname 
RUN apt-get -y build-dep linux linux-image-$UNAME
RUN apt-get install -y libncurses-dev gawk flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev autoconf llvm
RUN mkdir /build
RUN apt-get install -y git
RUN yes | unminimize
RUN useradd -u 1000 linuxbuild
RUN apt-get install -y fakeroot
RUN apt-get install -y sudo
RUN usermod -a -G sudo linuxbuild
RUN echo "linuxbuild    ALL=NOPASSWD: ALL" >/etc/sudoers.d/linuxbuild
USER linuxbuild
WORKDIR /build
ENV LANG=C

CMD ["/bin/bash", "--login"]
