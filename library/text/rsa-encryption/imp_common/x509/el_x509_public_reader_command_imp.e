note
	description: "Implementation of [$source EL_X509_PUBLIC_READER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-23 17:53:37 GMT (Friday 23rd July 2021)"
	revision: "6"

class
	EL_X509_PUBLIC_READER_COMMAND_IMP

inherit
	EL_X509_PUBLIC_READER_COMMAND_I
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