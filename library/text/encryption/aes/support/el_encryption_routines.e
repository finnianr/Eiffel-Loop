note
	description: "[
		Routines for AES encryption and creating SHA or MD5 digests. Accessible via [$source EL_MODULE_ENCRYPTION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 13:43:06 GMT (Wednesday 8th November 2023)"
	revision: "17"

class
	EL_ENCRYPTION_ROUTINES

inherit
	EL_AES_CONSTANTS
		export
			{ANY} valid_key_bit_count
		end

	EL_MODULE_BASE_64

	EL_SHARED_STRING_8_BUFFER_SCOPES

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

	new_aes_encrypter (pass_phrase: ZSTRING; bit_count: INTEGER): EL_AES_ENCRYPTER
		require
			valid_bit_count: valid_key_bit_count (bit_count)
		do
			create Result.make (pass_phrase, bit_count)
		end

feature {NONE} -- Implementation

	plain_text_from_line (a_file_path: FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_line_start: INTEGER): STRING
		local
			file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path)
			file.set_line_start (a_line_start)
			file.set_encrypter (a_encrypter)
			across string_8_scope as scope loop
				Result := scope.item
				from until file.end_of_file loop
					file.read_line_8
					if not Result.is_empty then
						Result.append_character ('%N')
					end
					Result.append (file.last_string_8)
					Result.prune_all_trailing ('%R')
				end
				Result := Result.twin
			end
			file.close
		end

end