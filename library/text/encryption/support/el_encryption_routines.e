note
	description: "Summary description for {EL_ENCRYPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 12:45:22 GMT (Tuesday 18th June 2013)"
	revision: "3"

class
	EL_ENCRYPTION_ROUTINES

inherit
	EL_BASE_64_ROUTINES

feature -- Conversion

	md5_digest_16 (string: STRING): ARRAY [NATURAL_8]
			--
		local
			md5: MD5
		do
			create md5.make
			create Result.make (1, 16)
			md5.sink_string (string)
			md5.do_final (Result.area, 0)
		end

	sha256_digest_32 (string: STRING): ARRAY [NATURAL_8]
			--
		local
			sha256: SHA256
		do
			create sha256.make
			create Result.make (1, 32)
			sha256.sink_string (string)
			sha256.do_final (Result.area, 0)
		end

	base64_decrypt (key, cipher: STRING): STRING
			-- decrypt base64 encoded cipher with base64 encoded key array
		local
			encrypter: EL_AES_ENCRYPTER
		do
			create encrypter.make_from_key (decoded_array (key))
			Result := encrypter.decrypted_base64 (cipher)
		end

	plain_text (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 0)
		end

	plain_pyxis (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER): STRING
		do
			Result := plain_text_from_line (a_file_path, a_encrypter, 3)
		end

feature {NONE} -- Implementation

	plain_text_from_line (a_file_path: EL_FILE_PATH; a_encrypter: EL_AES_ENCRYPTER; a_line_start: INTEGER): STRING
		local
			file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			create file.make_open_read (a_file_path.unicode)
			file.set_line_start (a_line_start)
			file.set_encrypter (a_encrypter)
			create Result.make (file.count * 7 // 10)
			from file.read_line until file.after loop
				if not Result.is_empty then
					Result.append_character ('%N')
				end
				Result.append (file.last_string)
				Result.prune_all_trailing ('%R')
				file.read_line
			end
			file.close
		end

end
