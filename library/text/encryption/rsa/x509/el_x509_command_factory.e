note
	description: "Summary description for {EL_X509_COMMAND_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 13:50:24 GMT (Thursday 23rd June 2016)"
	revision: "6"

class
	EL_X509_COMMAND_FACTORY

feature -- Factory

	new_certificate_reader (crt_file_path: EL_FILE_PATH): EL_X509_CERTIFICATE_READER_COMMAND_I
		do
			create {EL_X509_CERTIFICATE_READER_COMMAND_IMP} Result.make (crt_file_path)
		end

	new_key_reader (key_file_path: EL_FILE_PATH; pass_phrase: ZSTRING): EL_X509_KEY_READER_COMMAND_I
		do
			create {EL_X509_KEY_READER_COMMAND_IMP} Result.make (key_file_path, pass_phrase)
		end
end