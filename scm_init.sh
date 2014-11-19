#!/bin/bash
#
# Usage steps:
#
# $ ./init.sh

#
# Setup CONFIGs for user
#

# Folders hierarchy for Git Configuration items
# /etc/gitconfig
# ~/.gitconfig => alundiak@hmstn.com
# /PRJ/.git/config => landike@gmail.com

function initMe(){

	echo "Please type your First and Last name";
	read FL
	if [ -n "$FL" ]; then
	    git config --global user.name "$FL"
	else
	    git config --global user.name "Andrii Lundiak"
	fi

	echo "Please type your email";
	read EMAIL
	if [ -n "$EMAIL" ]; then
	    git config --global user.email "$EMAIL"
	else
	    git config --global user.email landike@gmail.com
	fi


	git config --global core.editor gedit

	# http://git-scm.com/docs/gitcredentials.html
	git config credential.helper store

	echo "Here is what your git repo config is now:"
	git config --list

}
#
# Init SOURCE files withing BitBucket
#
function initBB(){
	git hf init -f
	touch .gitignore
	printf ".idea\n*.iml" > .gitignore

	echo "Please type your BitBucket repository URL:";
	read MYBBREPO
	REPO_IS_VALID_URL="`curl -s --head "$MYBBREPO" | head -n 1 | grep "HTTP/"`";
	if [ -n "$MYBBREPO" -a -n "$REPO_IS_VALID_URL" ]; then
		git remote add origin $MYBBREPO
		git push -u origin --all
		#git push -u origin --tags
		echo -n "Now you may go and continue with your coding withing BitBucket repo"
	else
		echo "U've typed not valid URL. Please try again."
	fi

}

if [ "$1" == "--with-config" ]; then
	initMe
	initBB
else
	initBB
fi

