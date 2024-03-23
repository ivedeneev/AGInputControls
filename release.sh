#!/bin/bash
set -e

# Constants
PODSPEC_PATH=AGInputControls.podspec

CURRENT_VERSION=`agvtool mvers -terse1`
LAST_TAG=`git describe --abbrev=0`
current=($(echo $CURRENT_VERSION | tr "." "\n"))

#if we havent modified version ourselves(current version == last tag), bump patch version
if [[ $CURRENT_VERSION == $LAST_TAG ]];
then
    NEW_VERSION="${current[0]}.${current[1]}.$((current[2] + 1))"
else
    NEW_VERSION=$CURRENT_VERSION
fi

echo "Last tag: ${LAST_TAG}"
echo "New version: ${NEW_VERSION}"

# sed -i '' -e "s/$CURRENT_VERSION/$NEW_VERSION/" $PODSPEC_PATH
# agvtool new-marketing-version $NEW_VERSION

# git tag $CURRENT_VERSION
# git push origin $CURRENT_VERSION