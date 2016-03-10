note
	description: "Summary description for {EL_ENCRYPTED_FILE_LINE_SOURCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-26 9:24:45 GMT (Sunday 26th April 2015)"
	revision: "6"

class
	EL_ENCRYPTED_FILE_LINE_SOURCE

inherit
	EL_FILE_LINE_SOURCE
		rename
			make as make_line_source,
			text_file as encrypted_text_file
		redefine
			encrypted_text_file
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
		do
			make_latin_1 (a_file_path)
			encrypted_text_file.set_encrypter (a_encrypter)
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	encrypted_text_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE

end
