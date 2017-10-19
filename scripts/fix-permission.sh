#!/bin/sh
# This is a script to fix the permission to run as user aosp
ANDROID_SDK_HOME=/opt/android-sdk-linux

cd ${ANDROID_SDK_HOME}/tools
chmod g+x android ddms emulator* draw9patch hierarchyviewer jobb lint mksdcard monitor
chmod g+x monkeyrunner screenshot2 traceview uiautomatorviewer

cd ${ANDROID_SDK_HOME}/build-tools/
chmod g+x *

cd ${ANDROID_SDK_HOME}/platforms
chmod g+x *

chmod g+w ${ANDROID_SDK_HOME}/.android

