note
	description: "Reads file lines encrypted using AES cipher blocks chains"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 13:48:17 GMT (Tuesday 5th March 2019)"
	revision: "4"

class
	EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE

inherit
	EL_PLAIN_TEXT_LINE_SOURCE
		rename
			make as make_line_source
		redefine
			Default_file
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER)
		do
			make_latin (1, a_file_path)
			file.set_encrypter (a_encrypter)
		end

feature {NONE} -- Constants

	Default_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		once
			create Result.make_with_name (Precursor.path.name)
		end

end
