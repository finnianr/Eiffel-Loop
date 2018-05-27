note
	description: "Encryptable stored word token table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_ENCRYPTABLE_STORED_WORD_TOKEN_TABLE

inherit
	EL_STORED_WORD_TOKEN_TABLE
		redefine
			make_empty, new_word_file, open_write
		end

	EL_ENCRYPTABLE
		undefine
			is_equal, copy
		end

create
	make_empty, make_from_encrypted_file

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			if not attached encrypter then
				make_default_encryptable
			end
		end

	make_from_encrypted_file (a_file_path: EL_FILE_PATH; key_data: SPECIAL [NATURAL_8])
		do
			create encrypter.make_from_key (key_data)
			make_from_file (a_file_path)
		end

feature -- Status setting

	open_write
		do
			lio.enter ("open_write")
			Precursor
--			if lio.current_routine_is_active and then not words.is_empty then
--				from words.go_i_th (words.count - 5) until words.after loop
--					lio.put_string_field (words.index.out, words.item); lio.put_new_line
--					words.forth
--				end
--			end
			lio.exit
		end

feature {NONE} -- Implementation

	new_word_file (a_file_path: EL_FILE_PATH): EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (a_file_path)
			Result.set_encrypter (encrypter)
			Result.prepare_for_append
		end

end
