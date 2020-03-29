# Regression test all test tasks

f_code=build/linux-x86-64/EIFGENs/classic/F_code
if [ -f "$f_code/el_rhythmbox" ]; then
	app_path=$f_code/el_rhythmbox -test_manager -logging -config "$pyx_path"
else
	app_path=el_rhythmbox 
fi

for pyx_path in test-data/rhythmdb-tasks/*
do
	echo Executing $pyx_path ..
	$app_path -test_manager -logging -config "$pyx_path"
	status=$?
	if [ $status -gt 0 ]
	then
		echo Failed test\: $pyx_path ..
		read -p '<Return to continue>' str
	fi
done
$app_path -mp3_collate -test -logging

