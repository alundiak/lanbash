#!/bin/sh
#
# Setup Script - ton initial configuration of project

cd www/;
echo "Will try to create assest folder";
if [ ! -d "assets" ]; then
	mkdir assets;
	chmod 0777 assets;
	echo "*" > .gitignore;
	cat .gitignore;
fi

cd protected/;
echo "Will try to create runtime folder";
if [ ! -d "runtime" ]; then
	mkdir runtime/;
	chmod 0777 runtime;
	echo "*" > .gitignore;
	cat .gitignore;
fi