note
	description: "X509 RSA certificate routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-09 15:07:53 GMT (Tuesday 9th February 2021)"
	revision: "1"

expanded class
	EL_X509_ROUTINES

inherit
	ANY

	EL_MODULE_LIO

feature -- Basic operations

	write_key_file_to_aes (
		key_reader: EL_X509_KEY_READER_COMMAND_I; output_path: EL_FILE_PATH; aes_bit_count: INTEGER
	)
		-- exports key file at `key_file_path' to an AES encrypted file using same `credential'
		-- to both open key file and write AES file.
		-- if `output_path.is_empty' then writes to `key_file_path' with added "text.aes" extension

		require
			key_read: not key_reader.has_error
		local
			export_file_path: EL_FILE_PATH; cipher_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			if output_path.is_empty then
				export_file_path := key_reader.key_file_path.twin
				export_file_path.add_extension ("text.aes")
			else
				export_file_path := output_path
			end
			create cipher_file.make_open_write (export_file_path)
			cipher_file.set_encrypter (create {EL_AES_ENCRYPTER}.make (key_reader.credential.phrase, aes_bit_count))
			across key_reader.lines as line loop
				if is_lio_enabled then
					lio.put_line (line.item)
				end
				cipher_file.put_string (line.item)
				cipher_file.put_new_line
			end
			cipher_file.close
		end

end