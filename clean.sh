#!/bin/bash

TO_DELETE1="node_modules"

for ENTRY in `find ../  -name "$TO_DELETE1" -prune -depth +1 -print`
do
    echo "$ENTRY is being deleted..."
    rm -rf $ENTRY
    echo "$ENTRY has been deleted..."
done

TO_DELETE2="bower_components"

for ENTRY in `find ../  -name "$TO_DELETE2" -prune -depth +1 -print`
do
    echo "$ENTRY is being deleted..."
    rm -rf $ENTRY
    echo "$ENTRY has been deleted..."
done

echo "Clearing NPM cache..."
npm cache clean --force

echo "Clearing NPX cache..."
# https://stackoverflow.com/questions/63510325/how-can-i-clear-the-central-cache-for-npx
rm -rf ~/.npm/_npx

# https://yarnpkg.com/cli/cache/clean
# https://classic.yarnpkg.com/en/docs/cli/cache
yarn cache list
echo "Clearing Yarn cache..."
yarn cache clean --all

# Cleanup cached fiels by HomeBrew
# https://www.educative.io/edpresso/what-is-brew-cleanup
echo "Cleaning by HomeBrew..."
brew cleanup

# https://github.com/Homebrew/brew/issues/3784
echo "Clearing cached files from $(brew --cache) ..."
rm -rf $(brew --cache)

echo "Cleaning what left from Python/pip ..."
# rm -rf ~/Library/Caches/pip # doens't exists for me
#
# https://stackoverflow.com/questions/9510474/removing-pips-cache
pip3 cache list
# pip cache dir
# pip3 cache dir # => /Users/alund/Library/Caches/pip
pip3 cache purge

# echo "Clearing MacOS system cache ..."
# sudo rm -rf ~/Library/Caches/**
# since 2014-2017-2021 I got ~10GB of files there.
# So in 2021 I manually renamed fodler, and newlly aut-recreated Cache fodler got ~
# not permitted EVEN with sudo, so need to delete manually

# echo "Clearing deno cache ..."
# FYI From deno the docs https://deno.land/manual/linking_to_external_code :
# $HOME/Library/Caches/deno If something fails, it falls back to $HOME/.deno
# https://github.com/denoland/deno/issues/3437
# there is suggestion of feature.

echo "Clearing MacOS user cache ..."
rm -rf ~/.cache/**

echo "Clearing Dropbox logs user cache ..."
rm -rf ~/.dropbox/logs/**

echo "Clearing Cisco VPN user cache and logs ..."
rm -rf ~/.cisco/vpn/cache/**
rm -rf ~/.cisco/vpn/log/**

echo "Clearing 'not sure whose' (potentially Ruby) ~/.bundle cache ..."
rm -rf ~/.bundle/cache/**

echo "Clearing Anaconda temp files ..."
rm -rf ~/.anaconda/navigator/temp/**

echo "Clearing RN(ReactNative?) temp files ..."
rm -rf ~/.rncache/**

# maybe clean iMovie Render files
# Details: https://www.techjunkie.com/clear-disk-space-imovie/
# find ~/Movies/iMovie\ Library.imovielibrary -path “*/Render Files” -type d -exec rm -r {} +
# https://remarkablemark.org/blog/2016/06/04/free-up-imovie-disk-space/

