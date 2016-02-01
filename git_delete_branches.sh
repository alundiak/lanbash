#!/bin/bash

# http://stackoverflow.com/questions/10610327/delete-all-local-git-branches
# https://git-scm.com/docs/git-branch

gitbd() {
if [ $# -le 1 ]
  then
    local branches_to_delete=`git for-each-ref --format '%(refname:short)' refs/heads/ | grep "$1"`
    printf "Matching branches:\n\n$branches_to_delete\n\nDelete? [Y/n] "
    read -n 1 -r # Immediately continue after getting 1 keypress
    echo # Move to a new line
    if [[ ! $REPLY == 'N' && ! $REPLY == 'n' ]]
      then
        echo "??"
        # echo $branches_to_delete | xargs git branch -D
    fi
else
  echo "This command takes one arg (match pattern) or no args (match all)"
fi
}

# gitbd MYTMPL

# This script is still not ideal.
RELEASE_BRANCH="bragg"
CURRENT_BRANCH="MY-3460" # if branch doesn't exists, it
for mergedBranch in $(git branch --merged | grep -v "master" | grep -v "$RELEASE_BRANCH" | grep -v "$CURRENT_BRANCH" )
do
	echo ${mergedBranch}
  #git push origin :${mergedBranch}
  #git branch -d ${mergedBranch}
done

git remote update -p
git branch -a
