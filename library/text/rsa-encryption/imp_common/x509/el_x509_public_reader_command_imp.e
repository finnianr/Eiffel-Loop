note
	description: "Implementation of [$source EL_X509_PUBLIC_READER_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-20 9:23:43 GMT (Saturday 20th May 2023)"
	revision: "9"

class
	EL_X509_PUBLIC_READER_COMMAND_IMP

inherit
	EL_X509_PUBLIC_READER_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_CAPTURED_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "openssl x509 -in $crt_file_path -noout -text"

end