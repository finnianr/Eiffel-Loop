note
	description: "Summary description for {READ_X509_CERTIFICATE_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-15 15:03:01 GMT (Tuesday 15th September 2015)"
	revision: "6"

class
	EL_X509_CERTIFICATE_READER_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	template: STRING = "openssl x509 -in $crt_file_path -noout -text"

end
