note
	description: "Summary description for {ENCRYPTABLE_FILED_WORD_TOKEN_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-06 10:46:23 GMT (Wednesday 6th May 2015)"
	revision: "6"

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
			log.enter ("open_write")
			Precursor
			if log.current_routine_is_active and then not words.is_empty then
				from words.go_i_th (words.count - 5) until words.after loop
					log.put_string_field (words.index.out, words.item); log.put_new_line
					words.forth
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	new_word_file (a_file_path: EL_FILE_PATH): EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (a_file_path)
			Result.set_encrypter (encrypter)
			Result.prepare_for_append
		end

end
