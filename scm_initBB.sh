#!/bin/bash

cd ~/Projects/

git clone https://bitbucket.org/alundiak/scm_test
cd scm_test

git hf init

#git config --global core.editor gedit
git config --global credential.helper store
git config --global user.name "Andrii Lundiak"
git config --global user.email landike@gmail.com

git config user.name "yourFirst yourLast"
git config user.email your@mail.com

# Only for Empty repo
#git push -u origin --all

#printf ".idea\n*.iml" > .gitignore

git add -A

git st
