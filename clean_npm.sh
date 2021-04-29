#!/bin/bash

TO_DELETE="node_modules"

for ENTRY in `find ../  -name "$TO_DELETE" -prune -depth +1 -print`
do
    echo "$ENTRY is being deleted..."
    rm -rf $ENTRY
    echo "$ENTRY has been deleted..."
done

echo "Clearing NPM cache..."
npm cache clean --force

# https://yarnpkg.com/cli/cache/clean
# https://classic.yarnpkg.com/en/docs/cli/cache
yarn cache list
echo "Clearing Yarn cache..."
yarn cache clean --all
