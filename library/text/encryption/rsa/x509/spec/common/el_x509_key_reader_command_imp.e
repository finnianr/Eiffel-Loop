note
	description: "Implementation of `EL_X509_KEY_READER_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_X509_KEY_READER_COMMAND_IMP

inherit
	EL_X509_KEY_READER_COMMAND_I
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

	Template: STRING = "openssl rsa -noout -modulus -in $key_file_path -passin env:OPENSSL_PP -text"

end