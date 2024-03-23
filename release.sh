#!/bin/bash
set -e

# Constants
PODSPEC_PATH=AGInputControls.podspec

# update podspec && push
CURRENT_VERSION=`agvtool mvers -terse1`
NEW_VERSION='1.1.4'

sed -i '' -e "s/$CURRENT_VERSION/$NEW_VERSION/" $PODSPEC_PATH
# bump version if needed (if major & patch versions )
# agvtool new-marketing-version 1.1.4
LAST_TAG=`git describe --abbrev=0`
# echo ""
# echo "Current Version: ${CURRENT_VERSION} (${CURRENT_BUILD})"
# echo ""

# git tag $CURRENT_VERSION
# git push origin $CURRENT_VERSION