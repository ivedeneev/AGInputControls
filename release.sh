#!/bin/bash
set -e

# Constants
PODSPEC_PATH=AGInputControls.podspec


# bump version if needed (if major & patch versions )
agvtool next-version -all 

# update podspec && push
CURRENT_VERSION=`agvtool mvers -terse1`
CURRENT_BUILD=`agvtool vers -terse`

echo ""
echo "Current Version: ${CURRENT_VERSION} (${CURRENT_BUILD})"
echo ""