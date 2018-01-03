# This file copied from Internet, no idea where
lsbom -f -l -s -pf /var/db/receipts/org.nodejs.pkg.bom | while read f; do  sudo rm /usr/local/${f}; done

sudo rm -rf /usr/local/lib/node /usr/local/lib/node_modules /var/db/receipts/org.nodejs.*

sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}

brew uninstall node
brew prune
rm -f /usr/local/bin/npm
rm -f /usr/local/lib/dtrace/node.d
rm -rf /Users/alund/.npm


sudo rm -rf /usr/local/lib/node_modules/npm/
brew uninstall node
brew doctor



go to /usr/local/lib and delete any node and node_modules
go to /usr/local/include and delete any node and node_modules directory
if you installed with brew install node, then run brew uninstall node in your terminal
check your Home directory for any "local" or "lib" or "include" folders, and delete any "node" or "node_modules" from there
go to /usr/local/bin and delete any node executable
go to /usr/bin and delete any node executable



/usr/local/lib/node
/usr/local/include/node
/usr/local/lib/dtrace/node.d
/usr/local/share/man/man1/node.1
/usr/local/bin/npm
~/.npm (deleting this will erase your config)



https://github.com/DomT4
sudo rm /usr/local/include/node/* && sudo rm -rf /usr/local/include/node/* && sudo rm -rf /usr/local/lib/dtrace

&

sudo chown -R `whoami` /usr/local then brew post-install node.

