#
# Sublime 3 plugins setup script
#

PACKAGES=~/Library/Application\ Support/Sublime\ Text\ 3/Packages;

# Jade syntaxt
git clone https://github.com/miksago/jade-tmbundle.git "$PACKAGES/Jade";

# Stylus syntaxt
git clone https://github.com/LearnBoost/stylus.git "$PACKAGES/Stylus";

# CoffeeScript syntax
git clone https://github.com/Xavura/CoffeeScript-Sublime-Plugin.git "$PACKAGES/CoffeeScript";

# Looks like better plugin for CoffeeScript syntax
git clone https://github.com/aponxi/sublime-better-coffeescript.git "$PACKAGES/Better CoffeeScript";

# Plugin to reformat code by pressing Shift+Cmd+H
git clone https://github.com/victorporof/Sublime-HTMLPrettify.git "$PACKAGES/Sublime-HTMLPrettify";

# AngularJS plugin (code completion, snippets, go to definition, quick panel search)
git clone git://github.com/angular-ui/AngularJS-sublime-package.git "$PACKAGES/AngularJS";