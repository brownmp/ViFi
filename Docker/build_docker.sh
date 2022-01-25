#!/bin/bash

set -e



docker build --build-arg CACHEBUST=$(date +%s) -f Dockerfile -t brownmp/vifi:devel .

