#!/bin/bash

TO_DELETE="node_modules"

for ENTRY in `find ../  -name "$TO_DELETE" -prune -depth +1 -print`
do
    echo "Entities $TO_DELETE are being deleted..."
    rm -rf $ENTRY
    echo "Entities $TO_DELETE have been deleted..."
done
