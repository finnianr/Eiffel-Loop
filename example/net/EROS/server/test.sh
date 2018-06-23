
build/linux-x86-64/package/bin/el_eros -uninstall
RETVAL=$?
if [[ $RETVAL -eq 0 ]]
then
	echo Removing files
else
	echo Uninstall cancelled
fi
