EIFGENs/classic/F_code/el_server -uninstall
rm EIFGENs/classic/F_code/el_server
scons finalize=yes project=server.ecf
EIFGENs/classic/F_code/el_server -install

