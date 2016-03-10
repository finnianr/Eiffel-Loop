#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

sudo apt-get install python2.7-dev python-lxml scons libxrandr-dev
# Required for example/manage-mp3 
sudo apt-get install siggen libav-tools sox lame
if [ $? == "0" ]
then
	if [ ! -d ~/bin ]
	then
		mkdir ~/bin
	fi
	bin_path=~/bin
	eval bin_path=$bin_path
	sudo python setup.py install --install-scripts=/usr/local/bin
	python -m eiffel_loop.scripts.setup
else
	echo
	echo "ERROR: setup aborted."
	echo "Please install the 'apt-get' package manager or else edit this script to use your preferred package manager."
fi

