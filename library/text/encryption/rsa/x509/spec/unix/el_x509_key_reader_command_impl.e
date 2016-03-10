note
	description: "Summary description for {EL_X509_KEY_READER_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-15 14:59:53 GMT (Tuesday 15th September 2015)"
	revision: "6"

class
	EL_X509_KEY_READER_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	template: STRING = "openssl rsa -noout -modulus -in $key_file_path -passin env:OPENSSL_PP -text"

end
