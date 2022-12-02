#!/bin/bash
echo "Visit https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel for instructions"
docker run -v `pwd`:/build -v /boot:/boot -it linux_build
