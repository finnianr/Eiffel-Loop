note
	description: "Rsa public key encryption test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-13 10:49:03 GMT (Saturday 13th February 2021)"
	revision: "4"

class
	RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as Eiffel_loop_dir
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_X509_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("write_x509_key_file_to_aes_binary", agent test_write_x509_key_file_to_aes_binary)
			eval.call ("write_x509_key_file_to_aes_text", agent test_write_x509_key_file_to_aes_text)
		end

feature -- Tests

	test_write_x509_key_file_to_aes_binary
		note
			testing:
				"covers/{EL_X509_KEY_READER_COMMAND_I}.make, covers/{EL_X509_KEY_READER_COMMAND_I}.execute",
				"covers/{EL_RSA_PRIVATE_KEY}.make_from_stored, covers/{EL_RSA_PRIVATE_KEY}.store",
				"covers/{EL_RSA_PRIVATE_KEY}.is_equal"
		local
			reader_writer: ECD_ENCRYPTABLE_READER_WRITER [EL_RSA_PRIVATE_KEY]
			encrypter: EL_AES_ENCRYPTER; output_path: EL_FILE_PATH
			key_1, key_2: EL_RSA_PRIVATE_KEY
		do
			if file_list.is_empty then
				assert ("key file found", False)
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				create key_1.make_from_pkcs1_cert (file_list.first_path, Credential.phrase)
				assert ("key read", not key_1.is_default)
				assert_key_identity (key_1)

				create encrypter.make (Credential.phrase, 128)
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

	test_write_x509_key_file_to_aes_text
		note
			testing:
				"covers/{EL_X509_KEY_READER_COMMAND_I}.make, covers/{EL_X509_KEY_READER_COMMAND_I}.execute",
				"covers/{EL_RSA_PRIVATE_KEY}.make_from_pkcs1_cert, covers/{EL_RSA_PRIVATE_KEY}.make_from_pkcs1_file",
				"covers/{EL_RSA_PRIVATE_KEY}.is_equal"
		local
			key_reader: like new_key_reader; aes_lines: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE
			encrypter: EL_AES_ENCRYPTER; key_1, key_2: EL_RSA_PRIVATE_KEY
			output_path: EL_FILE_PATH
		do
			key_reader := new_key_reader
			output_path := key_reader.key_file_path.with_new_extension ("aes")

			lio.put_path_field ("Writing", output_path)
			lio.put_new_line
			key_reader.write_to_aes (128, output_path)

			lio.put_substitution ("create key_1.make_from_pkcs1_cert (%"%S%")", [key_reader.key_file_path])
			lio.put_new_line
			create key_1.make_from_pkcs1_cert (key_reader.key_file_path, credential.phrase)
			assert_key_identity (key_1)

			lio.put_substitution ("create key_2.make_from_pkcs1_file (%"%S%")", [output_path])
			lio.put_new_line
			create encrypter.make (key_reader.phrase, 128)
			create key_2.make_from_pkcs1_file (output_path, encrypter)

			assert ("same key", key_1 ~ key_2)
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

	new_key_reader: EL_X509_KEY_READER_COMMAND_I
		do
			if file_list.is_empty then
				assert ("key file found", False)
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				Result := X509_command.new_key_reader (file_list.first_path, Credential.phrase)
				Result.execute
				assert ("key read", not Result.has_error)
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("rsa_keys"), "*.key")
		end

feature {NONE} -- Constants

	Credential: EL_AES_CREDENTIAL
		once
			create Result.make ("hanami")
		end
end