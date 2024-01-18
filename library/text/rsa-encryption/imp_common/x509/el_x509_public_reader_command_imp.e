note
	description: "Implementation of ${EL_X509_PUBLIC_READER_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 7:49:07 GMT (Sunday 21st May 2023)"
	revision: "10"

class
	EL_X509_PUBLIC_READER_COMMAND_IMP

inherit
	EL_X509_PUBLIC_READER_COMMAND_I
		export
			{NONE} all
		end

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "openssl x509 -in $crt_file_path -noout -text"

end