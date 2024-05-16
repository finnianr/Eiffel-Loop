# Perform a web check for bad links etc on $HOME/www/eiffel-loop.com

# Start Cherokee HTTP server for eiffel-loop.com first before running this script

pushd .

cd $HOME/Documents

mkdir -p Reports/eiffel-loop.com
cd Reports/eiffel-loop.com

rm *

webcheck http://localhost/

popd

