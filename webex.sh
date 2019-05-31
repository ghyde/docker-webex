#!/bin/bash

set -e

docker rm --force webex >/dev/null 2>&1 || :
docker build --tag=webex:latest --no-cache .

# Sometimes the Webex client isn't compatable with newer versions of Firefox.
# Use timestamp tags to backup images.
docker tag webex:latest webex:$(date +"%Y%m%d")

./run-webex.sh
