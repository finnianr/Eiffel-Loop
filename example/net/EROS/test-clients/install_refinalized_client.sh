EIFGENs/eros_test/F_code/el_eros_test -uninstall
rm EIFGENs/eros_test/F_code/el_eros_test
scons finalize=yes project=eros-test.ecf
EIFGENs/eros_test/F_code/el_eros_test -install
