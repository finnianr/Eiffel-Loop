note
	description: "RSA public key encryption test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	RSA_PUBLIC_KEY_ENCRYPTION_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as eiffel_loop_dir
		end

	EL_MODULE_X509

	SHARED_DEV_ENVIRON

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("write_x509_key_file_to_aes_binary", agent test_write_x509_key_file_to_aes_binary)
		end

feature -- Tests

	test_write_x509_key_file_to_aes_binary
		note
			testing:
				"covers/{EL_X509_PUBLIC_READER_COMMAND_I}.make, covers/{EL_X509_PRIVATE_READER_COMMAND_I}.execute",
				"covers/{EL_RSA_PRIVATE_KEY}.make_from_stored, covers/{EL_RSA_PRIVATE_KEY}.store",
				"covers/{EL_RSA_PRIVATE_KEY}.is_equal"
		local
			reader_writer: ECD_ENCRYPTABLE_READER_WRITER [EL_RSA_PRIVATE_KEY]
			encrypter: EL_AES_ENCRYPTER; output_path: FILE_PATH
			key_1, key_2: EL_RSA_PRIVATE_KEY
		do
			if file_list.is_empty then
				assert ("key file found", False)
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				key_1 := X509_certificate.private (file_list.first_path, Credential.phrase)
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

feature {NONE} -- Implementation

	assert_key_identity (key: EL_RSA_PRIVATE_KEY)
		do
			assert ("correct modulus", key.modulus.out.starts_with ("c4a3e75600"))
			assert ("correct prime_1", key.prime_1.out.starts_with ("f0e4e983c73fa"))
			assert ("correct prime_2", key.prime_2.out.starts_with ("d0f8949dae"))
			assert ("correct private_exponent", key.private_exponent.out.starts_with ("b1f664774"))
			assert ("correct public_exponent", key.public_exponent.out ~ "10001")
		end

	eiffel_loop_dir: DIR_PATH
		do
			Result := Dev_environ.Eiffel_loop_dir
		end

	new_key_reader: EL_X509_PRIVATE_READER_COMMAND_I
		do
			if file_list.is_empty then
				assert ("key file found", False)
			else
				lio.put_path_field ("Reading", file_list.first_path)
				lio.put_new_line
				Result := X509_certificate.private_reader (file_list.first_path, Credential.phrase)
				Result.execute
				assert ("key read", not Result.has_error)
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Dev_environ.EL_test_data_dir #+ "rsa_keys", "*.key")
		end

feature {NONE} -- Constants

	Credential: EL_AES_CREDENTIAL
		once
			create Result.make ("hanami")
		end
end