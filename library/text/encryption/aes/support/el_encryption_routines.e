note
	description: "[
		Routines for AES encryption and creating SHA or MD5 digests. Accessible via [$source EL_MODULE_ENCRYPTION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-11 16:14:21 GMT (Friday 11th June 2021)"
	revision: "11"

class
	EL_ENCRYPTION_ROUTINES

inherit
	EL_AES_CONSTANTS
		export
			{ANY} valid_key_bit_count
		end

	EL_MODULE_BASE_64

feature -- Conversion

	base_64_decrypt (key, cipher: STRING): STRING
			-- decrypt base64 encoded cipher with base64 encoded key array
		local
			encrypter: EL_AES_ENCRYPTER
		do
			create encrypter.make_from_key (Base_64.decoded_special (key))
			Result := encrypter.decrypted_base_64 (cipher)
		end

	plain_pyxis (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 3)
		end

	plain_text (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
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

	plain_text_from_line (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_line_start: INTEGER): STRING
		local
			file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path)
			file.set_line_start (a_line_start)
			file.set_encrypter (a_encrypter)
			create Result.make (file.count * 7 // 10)
			from until file.end_of_file loop
				file.read_line
				if not Result.is_empty then
					Result.append_character ('%N')
				end
				Result.append (file.last_string)
				Result.prune_all_trailing ('%R')
			end
			file.close
		end

end