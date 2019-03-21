declare -x LANG="en_GB.UTF-8"

#read -p "Enter pass phrase: " pass_phrase

#export PASSPHRASE=$pass_phrase

pushd .
cd ~/dev/Eiffel

duplicity incremental --dry-run --verbosity info --encrypt-key VAL --exclude "**/build" --exclude "**/workarea" --exclude "**/.sconf_temp" --exclude "**/~" --exclude "**.a" --exclude "**.la" --exclude "**.lib" --exclude "**.obj" --exclude "**.o" --exclude "**.exe" --exclude "**.pyc" --exclude "**.evc" --exclude "**.dblite" --exclude "**.deps" --exclude "**.pdb" --exclude "**.yzip" --exclude "**.izip" --exclude "**.zip" --exclude "**.tar.gz" --exclude "**.lnk" --exclude "**.goutputstream**" --exclude "myching-server/resources/locale.??" --exclude "myching-server/www/images" myching-server "file:///home/finnian/Backups/duplicity/myching-server"

#duplicity incremental --dry-run --verbosity info --encrypt-key VAL --exclude \
#	"**/build" --exclude "**/workarea" --exclude "**/.sconf_temp" --exclude \
#	"**/~" --exclude "**.a" --exclude "**.la" --exclude "**.lib" --exclude \
#	"**.obj" --exclude "**.o" --exclude "**.exe" --exclude "**.pyc" --exclude \
#	"**.evc" --exclude "**.dblite" --exclude "**.deps" --exclude "**.pdb" \
#	--exclude "**.yzip" --exclude "**.izip" --exclude "**.zip" --exclude \
#	"**.tar.gz" --exclude "**.lnk" --exclude "**.goutputstream**" --exclude \
#	"myching-server/resources/locale.??" --exclude "myching-server/www/images" \
#	myching-server "file:///home/finnian/Backups/duplicity/myching-server"

popd
