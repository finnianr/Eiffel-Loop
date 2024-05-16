# Start Cherokee HTTP server for eiffel-loop.com
#
# LINKS in /var/www
# eiffel-loop.com -> $HOME/www/eiffel-loop.com

pushd .

cd /var/www

domain=eiffel-loop.com

if [ -d $domain ]; then
	sudo rm $domain
fi

sudo ln -s $HOME/www/$domain $domain

echo LINKS in /var/www
ls -l /var/www -l | cut -c40- | grep -F "$domain"

popd

sudo cherokee --config=$PWD/config/cherokee.conf
