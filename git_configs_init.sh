# This file copied from my REVIEW_FLASH_folder - when I worked for Medhost - SoftServe
#!/bin/bash

# to store password after first enter, and no asking in future
git config credential.helper store

# to allow adding changed file names (lower/upper case issue) into commit
git config core.ignorecase false

# To leave  CLRF as is (no need to change between Linux and Windows). Useful in case if initial Git client setup was performed with default settings, which is not ok.
git config core.autocrlf false

# To be sure, that we are using client credentials

echo "Please provide your first and last name (separated by space):"
read NAME
COLS=( $NAME );
FIRST=${COLS[0]};
LAST=${COLS[1]};

if [ -n $FIRST -a -n $LAST ]; then
    git config user.name "$FIRST $LAST"
    git config user.email "$FIRST.$LAST@medhost.com"
fi