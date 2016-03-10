note
	description: "Summary description for {EL_ENCRYPTED_PLAIN_TEXT_LINE_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 12:41:56 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_ENCRYPTED_PLAIN_TEXT_LINE_STATE_MACHINE

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE

	EL_ENCRYPTABLE
		rename
			set_encrypter as make
		end

create
	make

feature {NONE} -- Implementation

--	open_file (file_path: EL_FILE_PATH): like Type_text_file
--		do
--			create Result.make_open_read (file_path)
--			Result.set_encrypter (encrypter)
--		end

feature {NONE} -- Type definitions

--	Type_text_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE

end
