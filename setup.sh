#	author: "Finnian Reilly"
#	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
#	contact: "finnian at eiffel hyphen loop dot com"
#	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
#	date: "21 Dec 2012"
#	revision: "0.1"

sudo apt-get install python2.7-dev python-lxml scons
if [ $? == "0" ]
then
	sudo python setup.py install
	python -m eiffel_loop.scripts.setup
else
	echo
	echo "ERROR: setup aborted."
	echo "Please install the 'apt-get' package manager or else edit this script to use your preferred package manager."
fi

