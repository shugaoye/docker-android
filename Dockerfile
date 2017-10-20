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

FROM shugaoye/docker-android:sdk

MAINTAINER Roger Ye <shugaoye@yahoo.com>

#
# Beginning of NDK installation
#

RUN cd /opt && wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r15c-linux-x86_64.zip && \
    cd /opt && unzip android-ndk.zip && \
    cd /opt && rm -f android-ndk.zip && \
    cd /opt && ln -s android-ndk-r15c android-ndk-linux

ENV PATH ${PATH}:/opt/android-ndk-linux

#
# End of NDK installation
#

