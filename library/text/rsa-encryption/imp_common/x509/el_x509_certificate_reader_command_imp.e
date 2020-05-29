note
	description: "Implementation of [$source EL_X509_CERTIFICATE_READER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-28 9:28:51 GMT (Thursday 28th May 2020)"
	revision: "5"

class
	EL_X509_CERTIFICATE_READER_COMMAND_IMP

inherit
	EL_X509_CERTIFICATE_READER_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_parts
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "openssl x509 -in $crt_file_path -noout -text"

end
