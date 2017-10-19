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

#
# Beginning of SDK installation
#
# Copy install scripts
COPY scripts /root/scripts
RUN chmod 755 /root /root/scripts /root/scripts/android-accept-licenses.sh

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

# ------------------------------------------------------
# --- Install Android SDKs and other build packages

# Other tools and resources of Android SDK
#  you should only install the packages you need!
# To get a full list of available options you can use:
#  android list sdk --no-ui --all --extended
# (!!!) Only install one package at a time, as "echo y" will only work for one license!
#       If you don't do it this way you might get "Unknown response" in the logs,
#         but the android SDK tool **won't** fail, it'll just **NOT** install the package.
RUN echo y | android update sdk --no-ui --all --filter platform-tools | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter extra-android-support | grep 'package installed'

# SDKs
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter android-26 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-25 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-24 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-23 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-22 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-19 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-18 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-17 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter android-16 | grep 'package installed'

# build tools
# Please keep these in descending order!
RUN echo y | android update sdk --no-ui --all --filter build-tools-26.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-26.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-26.0.0 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-25.0.0 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-24.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-24.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-24.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.3 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.2 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-23.0.1 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter build-tools-19.1.0 | grep 'package installed'


# Android System Images, for emulators
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter sys-img-x86_64-android-25 | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter sys-img-x86-android-25 | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-25 | grep 'package installed'

RUN echo y | android update sdk --no-ui --all --filter sys-img-x86_64-android-24 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter sys-img-x86-android-24 | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-24 | grep 'package installed'

#RUN echo y | android update sdk --no-ui --all --filter sys-img-x86-android-23 | grep 'package installed'
#RUN echo y | android update sdk --no-ui --all --filter sys-img-armeabi-v7a-android-23 | grep 'package installed'

# Extras
RUN echo y | android update sdk --no-ui --all --filter extra-android-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-m2repository | grep 'package installed'
RUN echo y | android update sdk --no-ui --all --filter extra-google-google_play_services | grep 'package installed'

# install those?

# build-tools-21.0.0
#build-tools-21.0.1
#build-tools-21.0.2
#build-tools-21.1.0
#build-tools-21.1.1
#build-tools-21.1.2
#build-tools-22.0.0
#build-tools-22.0.1
#build-tools-23.0.0
#build-tools-23.0.1
#build-tools-23.0.2
#build-tools-23.0.3
#build-tools-24.0.0
#build-tools-24.0.1
#build-tools-24.0.2
#android-21
#android-22
#android-23
#android-24
#addon-google_apis-google-24
#addon-google_apis-google-23
#addon-google_apis-google-22
#addon-google_apis-google-21
#extra-android-support
#extra-android-m2repository
#extra-google-m2repository
#extra-google-google_play_services
#sys-img-arm64-v8a-android-24
#sys-img-armeabi-v7a-android-24
#sys-img-x86_64-android-24
#sys-img-x86-android-24

# google apis
# Please keep these in descending order!
#RUN echo y | android update sdk --no-ui --all --filter addon-google_apis-google-23 | grep 'package installed'

#Copy accepted android licenses
COPY licenses ${ANDROID_SDK_HOME}/licenses

#
# Update SDK
# May need to this offline, because of the build error.
#
# RUN /root/scripts/android-accept-licenses.sh android update sdk --no-ui --obsolete --force

RUN cd /opt && wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip && \
    cd /opt && unzip android-ndk.zip && \
    cd /opt && rm -f android-ndk.zip && \
    cd /opt && ln -s android-ndk-r15c android-ndk-linux

#
# End of SDK installation
#

USER root
    
# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache
ENV IMG_VERSION=1

# Work in the build directory, repo is expected to be init'd here
WORKDIR /home/aosp

COPY scripts/bash.bashrc /root/bash.bashrc
RUN chmod 755 /root/bash.bashrc
COPY scripts/docker_entrypoint.sh /root/docker_entrypoint.sh
ENTRYPOINT ["/root/docker_entrypoint.sh"]
