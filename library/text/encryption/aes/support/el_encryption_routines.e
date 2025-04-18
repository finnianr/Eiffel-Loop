note
	description: "[
		Routines for AES encryption and creating SHA or MD5 digests. Accessible via ${EL_MODULE_ENCRYPTION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-28 11:58:53 GMT (Friday 28th February 2025)"
	revision: "21"

class
	EL_ENCRYPTION_ROUTINES

inherit
	EL_AES_CONSTANTS
		export
			{ANY} valid_key_bit_count
		end

	EL_MODULE_BASE_64; EL_MODULE_DIGEST

	EL_SHARED_STRING_8_BUFFER_POOL

feature -- Conversion

	base_64_decrypt (key, cipher: STRING): STRING
			-- decrypt base64 encoded cipher with base64 encoded key array
		local
			encrypter: EL_AES_ENCRYPTER
		do
			create encrypter.make_from_key (Base_64.decoded_special (key))
			Result := encrypter.decrypted_base_64 (cipher)
		end

	plain_pyxis (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 3)
		end

	plain_text (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 0)
		end

feature -- Factory

	new_aes_encrypter (pass_phrase: READABLE_STRING_GENERAL; bit_count: INTEGER): EL_AES_ENCRYPTER
		require
			valid_bit_count: valid_key_bit_count (bit_count)
		do
			create Result.make (pass_phrase, bit_count)
		end

	new_key_data (a_phrase: READABLE_STRING_GENERAL): SPECIAL [NATURAL_8]
		-- securely created key data
		do
			if attached new_utf_8_phrase (a_phrase) as phrase_utf_8 then
				Result := Digest.sha_256 (phrase_utf_8)
				phrase_utf_8.fill_blank -- erase in memory
			end
		end

	new_utf_8_phrase (a_phrase: READABLE_STRING_GENERAL): STRING
		-- securely create UTF-8 encoding of `a_phrase'
		-- see `new_key_data' for usage example
		local
			l_phrase: ZSTRING
		do
			create l_phrase.make_from_general (a_phrase)
			Result := l_phrase.to_utf_8
			l_phrase.fill_blank -- erase in memory
		end

feature {NONE} -- Implementation

	plain_text_from_line (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_line_start: INTEGER): STRING
		local
			file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path)
			file.set_line_start (a_line_start)
			file.set_encrypter (a_encrypter)
			if attached String_8_pool.borrowed_item as buffer then
				Result := buffer.empty
				from until file.end_of_file loop
					file.read_line
					if not Result.is_empty then
						Result.append_character ('%N')
					end
					Result.append (file.last_string)
					Result.prune_all_trailing ('%R')
				end
				Result := Result.twin
				buffer.return
			end
			file.close
		end

end