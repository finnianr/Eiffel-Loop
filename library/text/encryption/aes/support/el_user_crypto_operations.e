note
	description: "[
		Common cryptographic operations that require user interaction
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 8:48:31 GMT (Wednesday 16th August 2023)"
	revision: "1"

expanded class
	EL_USER_CRYPTO_OPERATIONS

inherit
	EL_EXPANDED_ROUTINES

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_BASE_64; EL_MODULE_ENCRYPTION; EL_MODULE_LIO

	EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	STRING_HANDLER; EL_ZSTRING_CONSTANTS; EL_CHARACTER_CONSTANTS

	EL_SHARED_PASSPHRASE_TEXTS

feature -- Basic operations

	decrypt_file_with_aes
		do
			do_with_encrypted_file (agent write_plain_text)
		end

	display_encrypted_file
		do
			do_with_encrypted_file (agent display_plain_text)
		end

	display_encrypted_text (eiffel_array_output: BOOLEAN)
			--
		do
			if attached new_validated_credential as credential then
				display_cipher_text (new_encrypter (credential), User_input.line ("Enter text"), eiffel_array_output)
				
				if User_input.approved_action_y_n ("Show salt and digest") then
					credential.display (lio)
				end
			end
		end

	encrypt_file_with_aes
		local
			encrypter: like new_encrypter; input_path: FILE_PATH
		do
			input_path := new_drag_and_drop ("input", Void)
			if attached new_validated_credential as credential then
				credential.display (lio)
				encrypter := new_encrypter (credential)

				if User_input.approved_action_y_n ("Encrypt file") then
					lio.put_curtailed_string_field (
						"Key as base64", Base_64.encoded_special (encrypter.key_data, True), 300
					)
					lio.put_new_line

					encrypt_file (encrypter, input_path, aes_path (input_path))
				end
			end
		end

	generate_pass_phrase_salt
		do
			new_validated_credential.display (lio)
		end

	validate (credential: EL_AES_CREDENTIAL)
		local
			done: BOOLEAN
		do
			from until done loop
				credential.set_phrase (User_input.line (Text.enter_passphrase))
				lio.put_new_line
				if credential.is_salt_set then
					if credential.is_valid then
						done := True
					else
						lio.put_line (Text.passphrase_is_invalid)
					end
				else
					credential.validate
					done := True
				end
			end
		end

feature {NONE} -- Implementation

	aes_path (input_path: FILE_PATH): FILE_PATH
		do
			Result := input_path.twin
			Result.add_extension (Extension.aes)
		end

	display_cipher_text (encrypter: like new_encrypter; a_text: ZSTRING; eiffel_array_output: BOOLEAN)
		do
			a_text.replace_substring_all (Escaped_new_line, New_line * 1)

			if eiffel_array_output then
				lio.put_labeled_string ("Key array", encrypter.out)
			else
				lio.put_curtailed_string_field (
					"Key as base64", Base_64.encoded_special (encrypter.key_data, True), 300
				)
			end
			lio.put_new_line
			lio.put_labeled_string ("Cipher text", encrypter.base_64_encrypted (a_text.to_utf_8 (False)))
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
			input_path: FILE_PATH
		do
			input_path := new_drag_and_drop ("input", Void)
			lio.put_new_line
			if input_path.has_extension (Extension.aes) then
				if attached new_validated_credential as credential then
					action.call ([create {EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}.make (input_path, new_encrypter (credential))])
				end
			else
				lio.put_line ("Invalid file extension (.aes expected)")
			end
		end

	encrypt_file (encrypter: like new_encrypter; input_path, output_path: FILE_PATH)
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

				from plain_text.read_line_8 until plain_text.after loop
					cipher_file.put_raw_string_8 (plain_text.last_string_8)
					cipher_file.put_new_line
					plain_text.read_line_8
				end
				cipher_file.close; plain_text.close
			end
		end

	has_extension (path: FILE_PATH; a_extension: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := path.has_extension (a_extension)
		end

	to_crt_path (key_file_path: FILE_PATH): FILE_PATH
		do
			Result := key_file_path.without_extension -- remove .dat
			Result.replace_extension (Extension.crt)
		end

	valid_CSV_list (csv_list: STRING): BOOLEAN
		-- valid list for signing with x509 private key
		local
			list: EL_STRING_8_LIST
		do
			list := csv_list
			Result := across list as str all str.item.count <= 16 end
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

	new_bit_count: EL_USER_INPUT_VALUE [INTEGER]
		do
			create Result.make_valid ("AES encryption bit count", "Must be one of: 128, 256", agent AES_types.has)
		end

	new_validated_credential: EL_AES_CREDENTIAL
		do
			create Result.make_default
			validate (Result)
		end

	new_eiffel_source_name: FILE_PATH
		do
			Result := User_input.line ("Eiffel source name")
			if not Result.has_extension (Extension.e) then
				Result.add_extension (Extension.e)
			end
		end

	new_drag_and_drop (
		name: READABLE_STRING_GENERAL; valid_extension: detachable READABLE_STRING_GENERAL
	): EL_USER_INPUT_VALUE [FILE_PATH]
		local
			prompt: ZSTRING
		do
			prompt := "Drag and drop %S file"
			if attached valid_extension as ext then
				create Result.make_valid (prompt #$ [name], "Extension must be: *." + ext, agent has_extension (?, ext))
			else
				create Result.make (prompt #$ [name])
			end
			Result.check_existence
		end

	new_drag_and_drop_key_file: FILE_PATH
		local
			template: ZSTRING
		do
			template := "Key file data (*.%S)"
			Result := new_drag_and_drop (template #$ [Extension.key_dat], Extension.key_dat)
		end

	new_encrypter (pass_phrase: EL_AES_CREDENTIAL): EL_AES_ENCRYPTER
		do
			Result := pass_phrase.new_aes_encrypter (new_bit_count)
			lio.put_new_line
		end

feature {NONE} -- Constants

	AES_types: ARRAY [INTEGER]
		once
			Result := << 128, 256 >>
		end

	Escaped_new_line: ZSTRING
		once
			Result := "%%N"
		end

	Extension: TUPLE [aes, crt, dat, e, key, key_dat: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "aes, crt, dat, e, key, key.dat")
		end

end