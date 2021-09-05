note
	description: "[
		Menu driven shell of various cryptographic commands listed in function `new_command_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 8:24:07 GMT (Wednesday 1st September 2021)"
	revision: "30"

class
	EL_CRYPTO_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_BASE_64

	EL_MODULE_ENCRYPTION

	EL_MODULE_RSA

	EL_MODULE_TUPLE

	EL_MODULE_ZLIB

	EL_MODULE_X509

	STRING_HANDLER

create
	make

feature -- Basic operations

	decrypt_file_with_aes
		do
			do_with_encrypted_file (agent write_plain_text)
		end

	display_encrypted_file
		do
			do_with_encrypted_file (agent display_plain_text)
		end

	display_encrypted_text
			--
		do
			display_cipher_text (new_encrypter (new_credential), User_input.line ("Enter text"), False)
		end

	encrypt_file_with_aes
		local
			encrypter: like new_encrypter; credential: like new_credential
			input_path: EL_FILE_PATH
		do
			input_path := new_file_path ("input")
			credential := new_credential
			log_pass_phrase_info (credential)
			encrypter := new_encrypter (credential)

			if User_input.approved_action_y_n ("Encrypt file") then
				lio.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
				lio.put_new_line

				encrypt_file (encrypter, input_path, aes_path (input_path))
			end
		end

	export_x509_private_key_to_aes
		local
			key_file_path, export_path: EL_FILE_PATH; key_reader: like x509_certificate.private_reader
			credential: like new_credential; key_read: BOOLEAN
			key: EL_RSA_PRIVATE_KEY
		do
			from create key_file_path until key_file_path.has_extension (Extension.key) loop
				key_file_path := new_file_path ("private X509")
			end
			from until key_read loop
				credential := new_credential
				key_reader := X509_certificate.private_reader (key_file_path, credential.phrase)
				key_reader.execute
				if key_reader.has_error then
					across key_reader.errors as line loop
						lio.put_line (line.item)
					end
				else
					key_read := True
				end
			end
			if key_read then
				key := key_reader.private_key
				export_path := key_file_path.twin
				export_path.add_extension (Extension.dat)
				key.store (export_path, create {EL_AES_ENCRYPTER}.make (credential.phrase, new_bit_count))
			end
		end

	generate_pass_phrase_salt
		do
			log_pass_phrase_info (new_credential)
		end

	write_signed_CSV_list_with_x509_private_key
		local
			private_key: like new_private_key; string: ZSTRING
			signed_string: SPECIAL [NATURAL_8];  string_list: EL_STRING_8_LIST; s: EL_STRING_8_ROUTINES
			eiffel_class: EL_SIGNED_EIFFEL_CLASS; key_file_path: EL_FILE_PATH
		do
			key_file_path := new_key_file_path
			private_key := new_private_key (key_file_path)
			string := User_input.line ("Enter comma-separated list of strings to sign")
			if string.is_valid_as_string_8 then
				string_list := string.to_latin_1
				if across string_list as list all list.item.count <= 16 end then
					create eiffel_class.make (new_eiffel_source_name, serial_number (key_file_path))
					across string_list as list loop
						create signed_string.make_filled (0, 16)
						signed_string.copy_data (s.to_code_array (list.item), 0, 0, list.item.count)

						lio.put_labeled_string ("Signing", list.item)
						lio.put_new_line
						eiffel_class.field_list.extend (new_signed_field (private_key, list.item, signed_string))
					end
					eiffel_class.serialize
				else
					lio.put_labeled_string ("ERROR", "Each string count must be <= 16 characters")
					lio.put_new_line
				end
			else
				lio.put_labeled_string ("ERROR", "cannot be encoded with Latin-1 character set")
				lio.put_new_line
			end
		end

	write_x509_public_key_code_assignment
		local
			crt_file_path: EL_FILE_PATH; eiffel_source_name: EL_FILE_PATH; variable_name: ZSTRING
			eif_class: EL_PUBLIC_KEY_MANIFEST_CLASS
		do
			from create crt_file_path until crt_file_path.has_extension (Extension.crt) loop
				crt_file_path := new_file_path ("public X509 crt")
			end
			eiffel_source_name := new_eiffel_source_name
			variable_name := User_input.line ("Variable name")

			if variable_name.Is_valid_as_string_8 then
				if attached X509_certificate.public_reader (crt_file_path) as cmd then
					cmd.execute
					create eif_class.make (eiffel_source_name, cmd.serial_number)
					eif_class.field_list.extend (create {EL_PUBLIC_KEY_FIELD}.make (variable_name, cmd.public_key.modulus))
					eif_class.serialize
					lio.put_labeled_string ("Created", eiffel_source_name)
					lio.put_new_line
				end
			else
				lio.put_line ("Name may only contain Latin-1 characters")
			end
		end

feature {NONE} -- Implementation

	aes_path (input_path: EL_FILE_PATH): EL_FILE_PATH
		do
			Result := input_path.twin
			Result.add_extension (Extension.aes)
		end

	to_crt_path (key_file_path: EL_FILE_PATH): EL_FILE_PATH
		do
			Result := key_file_path.without_extension -- remove .dat
			Result.replace_extension (Extension.crt)
		end

	display_cipher_text (encrypter: like new_encrypter; text: ZSTRING; print_base_64: BOOLEAN)
		local
			s: EL_ZSTRING_ROUTINES
		do
			text.replace_substring_all (Escaped_new_line, s.character_string ('%N'))

			if print_base_64 then
				lio.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
			else
				lio.put_labeled_string ("Key array", encrypter.out)
			end
			lio.put_new_line
			lio.put_labeled_string ("Cipher text", encrypter.base_64_encrypted (text.to_utf_8 (False)))
			lio.put_new_line
		end

	display_plain_text (encrypted_lines: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE)
		do
			across encrypted_lines as line loop
				lio.put_line (line.item)
			end
		end

	do_with_encrypted_file (action: PROCEDURE [EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE])
		local
			input_path: EL_FILE_PATH
		do
			input_path := new_file_path ("input")
			lio.put_new_line
			if input_path.has_extension (Extension.aes) then
				action.call ([create {EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}.make (input_path, new_encrypter (new_credential))])
			else
				lio.put_line ("Invalid file extension (.aes expected)")
			end
		end

	encrypt_file (encrypter: like new_encrypter; input_path, output_path: EL_FILE_PATH)
		local
			cipher_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
		do
			lio.put_labeled_string ("Key", encrypter.out)
			lio.put_new_line
			lio.put_path_field ("Writing", output_path)
			lio.put_new_line
			if attached open (input_path, Read) as plain_text then
				create cipher_file.make_open_write (output_path)
				cipher_file.set_encrypter (encrypter)

				from plain_text.read_line until plain_text.after loop
					cipher_file.put_raw_string_8 (plain_text.last_string)
					cipher_file.put_new_line
					plain_text.read_line
				end
				cipher_file.close; plain_text.close
			end
		end

	log_pass_phrase_info (pass_phrase: EL_AES_CREDENTIAL)
		do
			lio.put_labeled_string ("Salt", pass_phrase.salt_base_64)
			lio.put_new_line
			lio.put_labeled_string ("Digest", pass_phrase.digest_base_64)
			lio.put_new_line
			lio.put_labeled_string ("Is valid", pass_phrase.is_valid.out)
			lio.put_new_line
		end

	serial_number (key_file_path: EL_FILE_PATH): STRING
		do
			if attached X509_certificate.public_reader (to_crt_path (key_file_path)) as cmd then
				cmd.execute
				Result := cmd.serial_number
			end
		end

	write_plain_text (encrypted_lines: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE)
		local
			out_file: EL_PLAIN_TEXT_FILE
		do
			create out_file.make_open_write (encrypted_lines.file_path.without_extension)
			across encrypted_lines as line loop
				out_file.put_string (line.item)
				out_file.put_new_line
			end
			out_file.close
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Display encrypted input text", 							agent display_encrypted_text],
				["Display AES encrypted file", 								agent display_encrypted_file],
				["Decrypt AES encrypted file", 								agent decrypt_file_with_aes],
				["Encrypt file with AES encryption", 						agent encrypt_file_with_aes],
				["Export private.key file to private.key.dat",			agent export_x509_private_key_to_aes],
				["Generate pass phrase salt", 								agent generate_pass_phrase_salt],
				["Write crt public key as Eiffel asssignment",			agent write_x509_public_key_code_assignment],
				["Write CSV list as RSA signed Eiffel assignments",	agent write_signed_CSV_list_with_x509_private_key]
			>>)
		end

	new_eiffel_source_name: EL_FILE_PATH
		do
			Result := User_input.line ("Eiffel source name")
			if not Result.has_extension (Extension.e) then
				Result.add_extension (Extension.e)
			end
		end

	new_encrypter (pass_phrase: EL_AES_CREDENTIAL): EL_AES_ENCRYPTER
		do
			Result := pass_phrase.new_aes_encrypter (new_bit_count)
			lio.put_new_line
		end

	new_bit_count: INTEGER
		do
			Result := User_input.integer_from_values ("AES encryption bit count", AES_types)
		end

	new_file_path (name: ZSTRING): EL_FILE_PATH
		local
			prompt: ZSTRING
		do
			prompt := "Drag and drop %S file"
			Result := User_input.file_path (prompt #$ [name])
			lio.put_new_line
		end

	new_credential: EL_AES_CREDENTIAL
		do
			create Result.make_default
			Result.ask_user
		end

	new_key_file_path: EL_FILE_PATH
		do
			from create Result until Result.has_extension (Extension.dat) loop
				Result := new_file_path (Extension.key + "." + Extension.dat)
			end
		end

	new_private_key (key_file_path: EL_FILE_PATH): EL_RSA_PRIVATE_KEY
		local
			encrypter: EL_AES_ENCRYPTER
		do
			-- Upgraded to 256 April 2015
			create encrypter.make (User_input.line ("Private key password"), 256)
			create Result.make_from_stored (key_file_path, encrypter)
		end

	new_signed_field (private_key: EL_RSA_PRIVATE_KEY; name: STRING; bytes: SPECIAL [NATURAL_8]): EL_SIGNED_EIFFEL_FIELD
		require
			correct_size: bytes.count = 16
		local
			signed_key: INTEGER_X
		do
			signed_key := private_key.sign (Rsa.integer_x_from_array (bytes))
			create Result.make (name, signed_key)
		end

feature {NONE} -- Constants

	AES_types: ARRAY [INTEGER]
		once
			Result := << 128, 256 >>
		end

	Extension: TUPLE [aes, crt, dat, e, key: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "aes, crt, dat, e, key")
		end

	Escaped_new_line: ZSTRING
		once
			Result := "%%N"
		end

end