note
	description: "Implementation of [$source EL_X509_PRIVATE_READER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:25:07 GMT (Wednesday 1st September 2021)"
	revision: "8"

class
	EL_X509_PRIVATE_READER_COMMAND_IMP

inherit
	EL_X509_PRIVATE_READER_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "openssl rsa -noout -modulus -in $key_file_path -passin env:OPENSSL_PP -text"

end