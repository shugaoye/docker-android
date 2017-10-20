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

FROM shugaoye/docker-android:android-18

MAINTAINER Roger Ye <shugaoye@yahoo.com>

#
# Beginning of installation
#

RUN echo y | android update sdk --no-ui --all --filter android-22 | grep 'package installed'

RUN echo y | android update sdk --no-ui --all --filter build-tools-22.0.1 | grep 'package installed'

#
# End of installation
#

