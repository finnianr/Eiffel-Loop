# Regression test all test tasks

f_code=build/linux-x86-64/EIFGENs/classic/F_code
if [ -f "$f_code/el_rhythmbox" ]; then
	$f_code/el_rhythmbox -rbox_autotest
else
	el_rhythmbox -rbox_autotest
fi
