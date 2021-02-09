note
	description: "Rsa public key encryption test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-09 15:04:35 GMT (Tuesday 9th February 2021)"
	revision: "2"

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
			eval.call ("write_x509_key_file_to_aes", agent test_write_x509_key_file_to_aes)
		end

feature -- Tests

	test_write_x509_key_file_to_aes
		note
			testing: "covers/{EL_X509_KEY_READER_COMMAND_I}.make, covers/{EL_X509_KEY_READER_COMMAND_I}.execute",
			"covers/{EL_X509_ROUTINES}.write_key_file_to_aes",
			"covers/{EL_RSA_PRIVATE_KEY}.make_from_pkcs1_cert, covers/{EL_RSA_PRIVATE_KEY}.make_from_pkcs1_file",
			"covers/{EL_RSA_PRIVATE_KEY}.is_equal"
		local
			key_reader: like X509_command.new_key_reader
			x509: EL_X509_ROUTINES; credential: EL_AES_CREDENTIAL
			file_path, output_path: EL_FILE_PATH;
			aes_lines: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE
			encrypter: EL_AES_ENCRYPTER; key_1, key_2: EL_RSA_PRIVATE_KEY
		do
			create credential.make ("hanami")
			if file_list.is_empty then
				assert ("key file present", False)
			else
				file_path := file_list.first_path
				output_path := file_path.with_new_extension ("aes")
				lio.put_path_field ("Writing", output_path)
				lio.put_new_line
				key_reader := X509_command.new_key_reader (file_path, credential)
				key_reader.execute
				assert ("key read", not key_reader.has_error)

				x509.write_key_file_to_aes (key_reader, output_path, 128)

				lio.put_substitution ("create key_1.make_from_pkcs1_cert (%"%S%")", [file_path])
				lio.put_new_line
				create key_1.make_from_pkcs1_cert (file_path, credential)

				assert ("correct modulus", key_1.modulus.out.starts_with ("c4a3e75600"))
				assert ("correct prime_1", key_1.prime_1.out.starts_with ("f0e4e983c73fa"))
				assert ("correct prime_2", key_1.prime_2.out.starts_with ("d0f8949dae"))
				assert ("correct private_exponent", key_1.private_exponent.out.starts_with ("b1f664774"))
				assert ("correct public_exponent", key_1.public_exponent.out ~ "10001")

				lio.put_substitution ("create key_2.make_from_pkcs1_file (%"%S%")", [output_path])
				lio.put_new_line
				create encrypter.make (credential.phrase, 128)
				create key_2.make_from_pkcs1_file (output_path, encrypter)

				assert ("same key", key_1 ~ key_2)
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (EL_test_data_dir.joined_dir_path ("rsa_keys"), "*.key")
		end

end