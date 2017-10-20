#!/bin/sh
# This is a script to fix the permission to run as user aosp
ANDROID_SDK_HOME=/opt/android-sdk-linux

cd ${ANDROID_SDK_HOME}/tools
chmod g+x android ddms emulator* draw9patch hierarchyviewer jobb lint mksdcard monitor
chmod g+x monkeyrunner screenshot2 traceview uiautomatorviewer

cd ${ANDROID_SDK_HOME}/build-tools/
chmod g+w *

cd ${ANDROID_SDK_HOME}/platforms
chmod g+w *

chmod g+w ${ANDROID_SDK_HOME}
chmod g+w ${ANDROID_SDK_HOME}/.android
chmod g+w ${ANDROID_SDK_HOME}/extras/android/*
chmod g+w ${ANDROID_SDK_HOME}/extras/google/*
chmod g+w ${ANDROID_SDK_HOME}/platform-tools
chmod g+w ${ANDROID_SDK_HOME}/tools


