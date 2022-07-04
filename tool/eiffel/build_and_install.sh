# build only using ecf (not .pecf) because "el_eiffel -pecf_to_xml" requires this project to be built first
ec_build_finalized.py --ecf --autotest --install /usr/local/bin
