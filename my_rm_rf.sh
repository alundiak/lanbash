#!/bin/bash

TO_DELETE="node_modules"

for ENTRY in `find ../  -name "$TO_DELETE" -prune -depth +1 -print`
do
    echo "$ENTRY is being deleted..."
    rm -rf $ENTRY
    echo "$ENTRY has been deleted..."
done
