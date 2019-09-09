# Regression test all test tasks

f_code=build/linux-x86-64/EIFGENs/classic/F_code
for pyx_path in test-data/rhythmdb-tasks/*
do
	echo Executing $pyx_path ..
	$f_code/el_rhythmbox -test_manager -logging -config "$pyx_path"
	status=$?
	if [ $status -gt 0 ]
	then
		echo Failed test: $pyx_path ..
	  break
	fi
done
if [ $status -eq 0 ]
then
	$f_code/el_rhythmbox -mp3_collate -test -logging
fi

