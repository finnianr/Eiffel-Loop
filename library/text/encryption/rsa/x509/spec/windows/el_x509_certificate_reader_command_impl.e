note
	description: "Summary description for {READ_X509_CERTIFICATE_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-19 16:45:53 GMT (Friday 19th September 2014)"
	revision: "4"

class
	EL_X509_CERTIFICATE_READER_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	template: STRING = "[
		openssl x509 -in "$crt_file_path" -noout -text
	]"

end
