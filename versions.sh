#!/bin/bash

#npm list -g --depth=0

echo "NodeJS: "`node -v`
echo "npm: "`npm -v`
echo "bower: "`bower -v`
echo "yarn: "`yarn -V`
echo "webpack: "`webpack -v`
echo "grunt: "`grunt --version`
echo "gulp: "`gulp -v`

echo "jslint: "`jslint -version`
jshint -v
echo "eslint: "`eslint -v`


echo "macOS: "`sw_vers`