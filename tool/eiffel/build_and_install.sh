ec_build_finalized.py --install /usr/local/bin

if [[ $? -eq 0 ]]; then
	el_eiffel -editor_autotest
	el_eiffel -pecf_to_xml -test
fi

