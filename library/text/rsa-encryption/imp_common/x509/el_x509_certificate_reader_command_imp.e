note
	description: "Implementation of [$source EL_X509_CERTIFICATE_READER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

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
