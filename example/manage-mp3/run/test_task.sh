# Regression test all test tasks

f_code=build/linux-x86-64/EIFGENs/classic/F_code
if [ -f "$f_code/el_rhythmbox" ]; then
	app_path=$f_code/el_rhythmbox -test_manager -logging -config "$pyx_path"
else
	app_path=el_rhythmbox 
fi

echo Executing $pyx_path ..
$app_path -test_manager -logging -config "test-data/rhythmdb-tasks/$1"

