note
	description: "Reads file lines encrypted using AES cipher blocks chains"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-08 10:37:03 GMT (Friday 8th May 2020)"
	revision: "6"

class
	EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_PLAIN_TEXT_LINE_SOURCE
		rename
			make as make_line_source
		redefine
			Default_file, new_file
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
		do
			make_line_source (Latin_1, a_file_path)
			file.set_encrypter (a_encrypter)
		end

feature {NONE} -- Implementation

	new_file (a_encoding: NATURAL; a_path: READABLE_STRING_GENERAL): like default_file
		do
			create Result.make_with_name (a_path)
		end

feature {NONE} -- Constants

	Default_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		once
			create Result.make_with_name (Precursor.path.name)
		end

end
