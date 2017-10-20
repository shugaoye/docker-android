# Copyright (C) 2017, Roger Ye 
# Android application development environment in a docker container
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#******************************************************************************
#
# Dockerfile - Dockerfile used to build the image
#
# Copyright (c) 2017 Roger Ye.  All rights reserved.
#
#******************************************************************************
#

FROM shugaoye/docker-aosp:ubuntu16.04-JDK8

MAINTAINER Roger Ye <shugaoye@yahoo.com>

RUN apt-get update

ENV PACKAGES git make vim-common vim-tiny wget curl libgtk2.0-0 libcanberra-gtk-module \
    xterm telnet mc inetutils-ping openssh-server net-tools expect \
    libc6-i386 libncurses5 libstdc++6 lib32z1 libbz2-1.0
RUN apt-get update \
    && apt-get -y install $PACKAGES

RUN mkdir /var/run/sshd
RUN export LC_ALL=C

RUN echo 'root:root' | chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/home/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV IMG_VERSION=1

COPY scripts/bash.bashrc /root/bash.bashrc
RUN chmod 755 /root /root/bash.bashrc
COPY scripts/docker_entrypoint.sh /root/docker_entrypoint.sh

#
# Beginning of SDK installation
#

RUN groupadd -g 2000 -r android
RUN useradd -u 2000 -M -s /bin/bash -g android android
RUN chown 2000 /opt
RUN umask 0002

USER android
ENV ANDROID_SDK_HOME /opt/android-sdk-linux
ENV ANDROID_HOME /opt/android-sdk-linux

RUN cd /opt && wget -q https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -O android-sdk.tgz
RUN cd /opt && tar -xvzf android-sdk.tgz
RUN cd /opt && rm -f android-sdk.tgz

ENV PATH ${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools:/root/bin


#
# End of SDK installation
#

