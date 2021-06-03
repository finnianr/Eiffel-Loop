note
	description: "[
		Menu driven shell of various cryptographic commands listed in function `new_command_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-03 15:12:07 GMT (Thursday 3rd June 2021)"
	revision: "22"

class
	EL_CRYPTO_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make_shell
		end

	EL_FILE_OPEN_ROUTINES

	EL_MODULE_BASE_64

	EL_MODULE_ENCRYPTION

	EL_MODULE_RSA

	EL_MODULE_X509_COMMAND

	SINGLE_MATH

	STRING_HANDLER

create
	make_shell

feature -- Basic operations

	decrypt_file_with_aes
		do
			lio.enter ("decrypt_file_with_aes")
			do_with_encrypted_file (agent write_plain_text)
			lio.exit
		end

	display_encrypted_file
		do
			lio.enter ("display_encrypted_file")
			do_with_encrypted_file (agent display_plain_text)
			lio.exit
		end

	display_encrypted_text
			--
		local
			encrypter: like new_encrypter
			text: ZSTRING; s: EL_ZSTRING_ROUTINES
		do
			lio.enter ("display_encrypted_text")
			encrypter := new_encrypter (new_credential)
			text := User_input.line ("Enter text")
			text.replace_substring_all (Escaped_new_line, s.character_string ('%N'))

			lio.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
			lio.put_new_line
			lio.put_labeled_string ("Key array", encrypter.out)
			lio.put_new_line
			lio.put_labeled_string ("Cipher text", encrypter.base_64_encrypted (text.to_utf_8 (False)))
			lio.put_new_line
			lio.exit
		end

	encrypt_file_with_aes
		local
			cipher_file: EL_ENCRYPTABLE_NOTIFYING_PLAIN_TEXT_FILE
			encrypter: like new_encrypter; credential: like new_credential
			input_path, output_path: EL_FILE_PATH
		do
			lio.enter ("encrypt_file_with_aes")
			input_path := new_file_path ("input")
			credential := new_credential
			log_pass_phrase_info (credential)
			encrypter := new_encrypter (credential)

			output_path := input_path.twin
			output_path.add_extension ("aes")

			lio.put_string ("Encrypt file (y/n): ")
			if User_input.entered_letter ('y') then

				lio.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
				lio.put_new_line
				lio.put_line ("Key: " + encrypter.out)

				if attached open (input_path, Read) as plain_text then
					create cipher_file.make_open_write (output_path)
					cipher_file.set_encrypter (encrypter)

					from plain_text.read_line until plain_text.after loop
						cipher_file.put_string (plain_text.last_string)
						cipher_file.put_new_line
						plain_text.read_line
					end
					cipher_file.close; plain_text.close
				end
			end
			lio.exit
		end

	export_x509_private_key_to_aes
		local
			key_file_path, export_path: EL_FILE_PATH; key_reader: like X509_command.new_key_reader
			credential: like new_credential; key_read: BOOLEAN
			key: EL_RSA_PRIVATE_KEY
		do
			lio.enter ("export_x509_private_key_to_aes")
			from create key_file_path until key_file_path.has_extension ("key") loop
				key_file_path := new_file_path ("private X509")
			end
			from until key_read loop
				credential := new_credential
				key_reader := X509_command.new_key_reader (key_file_path, credential.phrase)
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
				create key.make_from_pkcs1 (key_reader.lines)
				export_path := key_file_path.twin
				export_path.add_extension ("dat")
				key.store (export_path, create {EL_AES_ENCRYPTER}.make (credential.phrase, new_bit_count))
			end
			lio.exit
		end

	generate_pass_phrase_salt
		do
			lio.enter ("generate_pass_phrase_salt")
			log_pass_phrase_info (new_credential)
			lio.exit
		end

	write_string_signed_with_x509_private_key
		local
			private_key: like new_private_key; string: ZSTRING; source_code: PLAIN_TEXT_FILE
			signed_string: SPECIAL [NATURAL_8]; variable_name: STRING
		do
			lio.enter ("write_string_signed_with_x509_private_key")
			private_key := new_private_key
			string := User_input.line ("Enter string to sign")
			create signed_string.make_filled (0, 16)
			signed_string.base_address.memory_copy (string.area.base_address, string.count.max (16))

			variable_name := User_input.line ("Variable name").to_string_8
			create source_code.make_open_write (new_eiffel_source_name)

			write_signed_array_eiffel_code_assignment (private_key, source_code, variable_name, signed_string)
			source_code.close
			lio.exit
		end

	write_x509_public_key_code_assignment
		local
			variable_name: STRING; public_key: EL_RSA_PUBLIC_KEY
			crt_file_path: EL_FILE_PATH; eiffel_source_name: like new_eiffel_source_name
			source_code: PLAIN_TEXT_FILE
		do
			lio.enter ("write_x509_public_key_code_assignment")
			from create crt_file_path until crt_file_path.has_extension ("crt") loop
				crt_file_path := new_file_path ("public x509")
			end
			eiffel_source_name := new_eiffel_source_name
			variable_name := User_input.line ("Variable name").to_string_8

			create source_code.make_open_write (eiffel_source_name)
			create public_key.make_from_x509_cert (crt_file_path)
			write_public_key_eiffel_code_assignment (source_code, variable_name, public_key.modulus.as_bytes)
			source_code.close
			lio.put_labeled_string ("Created", eiffel_source_name)
			lio.exit
		end

feature {NONE} -- Implementation

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
			if input_path.has_extension ("aes") then
				action.call ([create {EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE}.make (input_path, new_encrypter (new_credential))])
			else
				lio.put_line ("Invalid file extension (.aes expected)")
			end
		end

	factorized (n: INTEGER): STRING
		local
			factor: INTEGER
		do
			create Result.make (10)
			from factor := 2 until n \\ factor = 0 or factor > sqrt (n).rounded loop
				factor := factor + 1
			end
			if n \\ factor = 0 then
				Result.append_integer (factor)
				Result.append_character ('*')
				Result.append_integer (n // factor)
			else
				Result.append_integer (n)
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

	write_base64_eiffel_code_assignment (source_code: PLAIN_TEXT_FILE; name: STRING; array: SPECIAL [NATURAL_8])
		local
			base64_string: STRING
			count_per_line, i, start_index, end_index: INTEGER
		do
			base64_string := Base_64.encoded_special (array)
			count_per_line := base64_string.count // 4
			source_code.put_string (name); source_code.put_string (" := Base_64.joined (%"[")
			source_code.put_new_line
			from i := 0 until i > 3 loop
				start_index := i * count_per_line + 1
				end_index := i * count_per_line + count_per_line
				source_code.put_character ('%T'); source_code.put_string (base64_string.substring (start_index, end_index))
				source_code.put_new_line
				i := i + 1
			end
			source_code.put_string ("]%")")
			source_code.put_new_line
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

	write_public_key_eiffel_code_assignment (source_code: PLAIN_TEXT_FILE; name: STRING; array: SPECIAL [NATURAL_8])
			-- Intended to create a manifest format that is more difficult to tamper with at machine code level
			-- Anti-piracy measure
		local
			count_per_line, i: INTEGER
		do
			count_per_line := 18
			source_code.put_string (name); source_code.put_string (" := <<")
			from i := 0 until i > array.upper loop
				if i \\ count_per_line = 0 then
					source_code.put_new_line
					source_code.put_character ('%T')
				end
				source_code.put_string (factorized (array [i]))
				i := i + 1
				if i >= 1 and i <= array.upper then
					source_code.put_string (", ")
				end
			end
			source_code.put_new_line
			source_code.put_string (">>")
			source_code.put_new_line
		end

	write_signed_array_eiffel_code_assignment (
		private_key: EL_RSA_PRIVATE_KEY; a_file: PLAIN_TEXT_FILE; name: STRING; bytes: SPECIAL [NATURAL_8]
	)
		require
			correct_size: bytes.count = 16
		local
			signed_key: INTEGER_X
		do
			signed_key := private_key.sign (Rsa.integer_x_from_array (bytes))
			write_base64_eiffel_code_assignment (a_file, name, signed_key.as_bytes)
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Display encrypted input text", 						agent display_encrypted_text],
				["Display AES encrypted file", 							agent display_encrypted_file],
				["Decrypt AES encrypted file", 							agent decrypt_file_with_aes],
				["Encrypt file with AES encryption", 					agent encrypt_file_with_aes],
				["Export private.key file to private.key.dat",		agent export_x509_private_key_to_aes],
				["Generate pass phrase salt", 							agent generate_pass_phrase_salt],
				["Write crt public key as Eiffel asssignment",		agent write_x509_public_key_code_assignment],
				["Write RSA signed string as Eiffel assignment",	agent write_string_signed_with_x509_private_key]
			>>)
		end

	new_eiffel_source_name: EL_FILE_PATH
		do
			Result := User_input.line ("Eiffel source name")
			if not Result.has_extension ("e") then
				Result.add_extension ("e")
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

	new_private_key: EL_RSA_PRIVATE_KEY
		local
			key_file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER
		do
			from create key_file_path until key_file_path.has_extension ("aes") loop
				key_file_path := new_file_path ("key.dat")
			end
			-- Upgraded to 256 April 2015
			create encrypter.make (User_input.line ("Private key password"), 256)
			create Result.make_from_stored (key_file_path, encrypter)
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

end