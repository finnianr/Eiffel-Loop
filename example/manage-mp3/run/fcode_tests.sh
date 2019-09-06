f_code=build/linux-x86-64/EIFGENs/classic/F_code
for pyx_path in test-data/rhythmdb-tasks/publish_dj_events.pyx
do
	echo Executing $pyx_path ..
	$f_code/el_rhythmbox -test_manager -logging -config "$pyx_path"
	if [ $? -gt 0 ]
	then
		echo Failed test: $pyx_path ..
	  break
	fi
done
