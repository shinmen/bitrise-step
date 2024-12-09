#!/bin/bash

set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail
# debug log
set -x

BUILD_FILE="${BUILD_FILE_ENV:-$PWD/build.gradle}"

VERSION_EXTRACTOR="${VERSION_EXTRACTOR_ENV:-grep -E 'javaVersion\\s*=' \"$BUILD_FILE\" | sed -E 's/.*JavaVersion\\.VERSION_([0-9]+).*/\\1/'}"

javaVersion=$(eval "$VERSION_EXTRACTOR")

if [[ -n "$javaVersion" ]]; then
    echo "javaVersion: $javaVersion"
else
    echo "javaVersion not found in $BUILD_FILE"
    exit 1;
fi

envman add --key JAVA_VERSION --value "${javaVersion}"