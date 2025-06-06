note
	description: "RSA public key encryption test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:13:19 GMT (Sunday 4th May 2025)"
	revision: "15"

class
	RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET

inherit
	COPIED_FILE_DATA_TEST_SET

	EL_MODULE_X509

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["write_x509_key_file_to_aes_binary", agent test_write_x509_key_file_to_aes_binary]
			>>)
		end

feature -- Tests

	test_write_x509_key_file_to_aes_binary
		note
			testing:
				"covers/{EL_X509_PUBLIC_READER_COMMAND_I}.make, covers/{EL_X509_PRIVATE_READER_COMMAND_I}.execute",
				"covers/{EL_RSA_PRIVATE_KEY}.make_from_stored, covers/{EL_RSA_PRIVATE_KEY}.store",
				"covers/{EL_RSA_PRIVATE_KEY}.is_equal"
		local
			encrypter: EL_AES_ENCRYPTER; output_path: FILE_PATH; key_1, key_2: EL_RSA_PRIVATE_KEY
			reader_writer: ECD_ENCRYPTABLE_READER_WRITER [EL_RSA_PRIVATE_KEY]
		do
			if file_list.is_empty then
				failed ("key file found")
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				key_1 := X509_certificate.private (file_list.first_path, Phrase)
				assert ("key read", not key_1.is_default)
				assert_key_identity (key_1)

				create encrypter.make (Phrase, 128)
				create reader_writer.make (encrypter)
				output_path := file_list.first_path.with_new_extension ("aes")
				lio.put_path_field ("Writing", output_path)
				lio.put_new_line
				key_1.store (output_path, encrypter)
				lio.put_path_field ("Reading", output_path)
				lio.put_new_line
				create key_2.make_from_stored (output_path, encrypter)
				assert ("same key", key_1 ~ key_2)
			end
		end

feature {NONE} -- Implementation

	assert_key_identity (key: EL_RSA_PRIVATE_KEY)
		do
			assert ("correct modulus", key.modulus.out.starts_with ("c4a3e75600"))
			assert ("correct prime_1", key.prime_1.out.starts_with ("f0e4e983c73fa"))
			assert ("correct prime_2", key.prime_2.out.starts_with ("d0f8949dae"))
			assert ("correct private_exponent", key.private_exponent.out.starts_with ("b1f664774"))
			assert ("correct public_exponent", key.public_exponent.out ~ "10001")
		end

	new_key_reader: EL_X509_PRIVATE_READER_COMMAND_I
		do
			if file_list.is_empty then
				failed ("key file found")
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				Result := X509_certificate.private_reader (file_list.first_path, Phrase)
				Result.execute
				assert ("key read", not Result.has_error)
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir.rsa_keys, "*.key")
		end

feature {NONE} -- Constants

	Phrase: STRING = "hanami"

end