note
	description: "Implementation of `EL_X509_CERTIFICATE_READER_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 13:39:53 GMT (Thursday 23rd June 2016)"
	revision: "1"

class
	EL_X509_CERTIFICATE_READER_COMMAND_IMP

inherit
	EL_X509_CERTIFICATE_READER_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "openssl x509 -in $crt_file_path -noout -text"

end