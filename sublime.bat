echo off
REM
REM Sublime 3 plugins setup script
REM

SET PACKAGES=%APPDATA%/Sublime\ Text\ 3/Packages/TEST;

REM Jade syntaxt
git clone https://github.com/miksago/jade-tmbundle.git "$PACKAGES/Jade";

REM Stylus syntaxt
git clone https://github.com/LearnBoost/stylus.git "$PACKAGES/Stylus";

REM CoffeeScript syntax
git clone https://github.com/Xavura/CoffeeScript-Sublime-Plugin.git "$PACKAGES/CoffeeScript";

REM Looks like better plugin for CoffeeScript syntax
git clone https://github.com/aponxi/sublime-better-coffeescript.git "$PACKAGES/Better CoffeeScript";

REM Plugin to reformat code by pressing Shift+Cmd+H
git clone https://github.com/victorporof/Sublime-HTMLPrettify.git "$PACKAGES/Sublime-HTMLPrettify";

REM AngularJS plugin (code completion, snippets, go to definition, quick panel search)
git clone git://github.com/angular-ui/AngularJS-sublime-package.git "$PACKAGES/AngularJS";

