Android Application Development Environment in a Docker Container
=================================================================

[![](https://images.microbadger.com/badges/image/shugaoye/docker-android.svg)](https://microbadger.com/images/shugaoye/docker-android "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/shugaoye/docker-android.svg)](https://microbadger.com/images/shugaoye/docker-android "Get your own version badge on microbadger.com")

The docker images can be download at:
https://hub.docker.com/r/shugaoye/docker-android/

#Using adb
To use adb inside the container, please start the container with the below option:
-v /dev/bus/usb:/dev/bus/usb

Don't use adb in the host. Refer to the Makefile about how to start the container.

For a more complicated case about how to use adb inside a container, please refer to
https://github.com/sorccu/docker-adb
