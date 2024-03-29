#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

# cmake required to make taglib.ecf

for name in automake autoconf cmake lftp libtool libxrandr-dev librsvg2-dev patch python2.7-dev python-lxml scons; do
	install_status="$(dpkg -s $name 2>/dev/null | grep -c "install ok")"
	if [[ $install_status -eq "0" ]]; then
		sudo apt-get install $name
	else
		echo "Checking for $name OK"
	fi
done

# Required for example/manage-mp3 and toolkit
sudo apt-get install siggen libav-tools sox lame exiv2
if [ $? == "0" ]
then
	curl_lib=cURL/spec/$ISE_PLATFORM/lib
	if [ -f $ISE_LIBRARY/library/$curl_lib/MTeiffel_curl.o ]; then
		echo Found MTeiffel_curl.o
	else
		# Build and install MTeiffel_curl.o
		cp -r $ISE_LIBRARY/library/cURL .
		pushd .
		cd cURL/Clib
		finish_freezing -library
		popd
		sudo cp $curl_lib/MTeiffel_curl.o $ISE_LIBRARY/library/$curl_lib
		rm -r cURL
	fi
	sudo python setup.py build -b build/$ISE_PLATFORM install --install-scripts=/usr/local/bin
	python -m eiffel_loop.scripts.setup
else
	echo
	echo "ERROR: setup aborted."
	echo "Please install the 'apt-get' package manager or else edit this script to use your preferred package manager."
fi

