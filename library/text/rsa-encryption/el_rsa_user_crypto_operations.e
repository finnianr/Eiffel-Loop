note
	description: "[
		${EL_USER_CRYPTO_OPERATIONS} with addition of RSA public-key cryptography operations
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-06 8:20:11 GMT (Tuesday 6th May 2025)"
	revision: "5"

expanded class
	EL_RSA_USER_CRYPTO_OPERATIONS

inherit
	EL_USER_CRYPTO_OPERATIONS_I

	EL_EXPANDED_ROUTINES

	EL_MODULE_RSA; EL_MODULE_X509

feature -- Basic operations

	export_x509_private_key_to_aes
		local
			key_file_path, export_path: FILE_PATH; key_reader: like x509_certificate.private_reader
			key_read: BOOLEAN; key: EL_RSA_PRIVATE_KEY; phrase: ZSTRING
		do
			key_file_path := new_drag_and_drop ("private X509", Extension.key)
			from until key_read loop
				phrase := new_input_phrase
				key_reader := X509_certificate.private_reader (key_file_path, phrase)
				key_reader.execute
				if key_reader.has_error then
					key_reader.print_error ("exporting")
				else
					key_read := True
					Validation_prompt.put (Void)
				end
			end
			if key_read then
				key := key_reader.private_key
				export_path := key_file_path.twin
				export_path.add_extension (Extension.dat)
				key.store (export_path, create {EL_AES_ENCRYPTER}.make (phrase, new_bit_count))
			end
		end

	write_signed_CSV_list_with_x509_private_key
		local
			private_key: like new_private_key
			string_list: EL_STRING_8_LIST; sg: EL_STRING_GENERAL_ROUTINES; csv_list: EL_USER_INPUT_VALUE [STRING]
			eiffel_class: EL_SIGNED_EIFFEL_CLASS; key_file_path: FILE_PATH
		do
			key_file_path := new_drag_and_drop_key_file
			private_key := new_private_key (key_file_path)

			create csv_list.make_valid (
				"Enter comma-separated list of strings to sign", "Each item must have <= 16 characters", agent valid_csv_list
			)
			string_list := csv_list.value

			create eiffel_class.make (new_eiffel_source_name, serial_number (key_file_path))
			across string_list as list loop
				lio.put_labeled_string ("Signing", list.item)
				lio.put_new_line
				if attached sg.super_8 (list.item).to_fixed_code_array (16) as signed_string then
					eiffel_class.field_list.extend (new_signed_field (private_key, list.item, signed_string))
				end
			end
			eiffel_class.serialize
		end

	write_x509_public_key_code_assignment
		local
			crt_file_path: FILE_PATH; eiffel_source_name: FILE_PATH; variable_name: ZSTRING
			eif_class: EL_PUBLIC_KEY_MANIFEST_CLASS
		do
			crt_file_path := new_drag_and_drop ("public X509 crt", Extension.crt)
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

	serial_number (key_file_path: FILE_PATH): STRING
		do
			if attached X509_certificate.public_reader (to_crt_path (key_file_path)) as cmd then
				cmd.execute
				Result := cmd.serial_number
			end
		end

feature {NONE} -- Factory

	new_private_key (key_file_path: FILE_PATH): EL_RSA_PRIVATE_KEY
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

end