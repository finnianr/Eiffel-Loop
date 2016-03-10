date_stamp=$(date)
echo "<!--Build: $date_stamp-->" >> toolkit.ecf
scons action=finalize project=toolkit.ecf
cp package/bin/el_toolkit ~/bin
