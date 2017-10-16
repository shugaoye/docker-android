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

ENV PACKAGES git make vim-common vim-tiny \
    xterm telnet mc inetutils-ping openssh-server net-tools expect
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

# Install Android Studio
ENV VERSION_SDK_TOOLS "3859397"
ENV VERSION_ANDROID_STUDIO "162.4069837"

ENV ANDROID_HOME "/opt/android-sdk-linux"
ENV PATH "$PATH:${ANDROID_HOME}/tools"

ENV AS_URL="https://dl.google.com/dl/android/studio/ide-zips/2.3.3.0/android-studio-ide-${VERSION_ANDROID_STUDIO}-linux.zip"
RUN curl $AS_URL > /tmp/studio.zip && \
    unzip -d /opt /tmp/studio.zip && \
    rm /tmp/studio.zip

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-${VERSION_SDK_TOOLS}.zip"
RUN curl $SDK_URL > /tmp/sdk.zip && \
    unzip -d ${ANDROID_HOME} /tmp/sdk.zip && \
    rm /tmp/sdk.zip

RUN mkdir -p $ANDROID_HOME/licenses/ \
  && echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license \
  && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

ADD scripts/packages.txt /root/packages.txt
ADD scripts/android-accept-licenses.sh /root/android-accept-licenses.sh
RUN mkdir -p /root/.android && \
  touch /root/.android/repositories.cfg 

RUN ["/root/android-accept-licenses.sh", "/opt/android-sdk-linux/tools/bin/sdkmanager --update --verbose"]

RUN while read -r package; do SDK_PACKAGES="${SDK_PACKAGES}${package} "; done < /root/packages.txt && \
    ${ANDROID_HOME}/tools/bin/sdkmanager --verbose ${SDK_PACKAGES}
    
# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV IMG_VERSION=1

# Work in the build directory, repo is expected to be init'd here
WORKDIR /home/aosp

COPY scripts/bash.bashrc /root/bash.bashrc
RUN chmod 755 /root /root/bash.bashrc
COPY scripts/docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
