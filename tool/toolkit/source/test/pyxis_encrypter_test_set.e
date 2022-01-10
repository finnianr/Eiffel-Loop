note
	description: "Test class [$source PYXIS_ENCRYPTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 10:34:51 GMT (Monday 10th January 2022)"
	revision: "1"

class
	PYXIS_ENCRYPTER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EL_MODULE_ENCRYPTION

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("execute", agent test_execute)
		end

feature -- Tests

	test_execute
		local
			table, decrypted_table: EL_TRANSLATION_TABLE
			plain_text: STRING; aes_encrypter: EL_AES_ENCRYPTER
			pyxis_encrypter: PYXIS_ENCRYPTER; file_path: FILE_PATH
		do
			file_path := file_list.first_path
			create aes_encrypter.make ("secret", 128)
			create pyxis_encrypter.make (file_path, create {FILE_PATH}, aes_encrypter)
			pyxis_encrypter.execute
			aes_encrypter.reset
			plain_text := Encryption.plain_pyxis (pyxis_encrypter.output_path, aes_encrypter)

			across << "en", "de" >> as language loop
				create decrypted_table.make_from_pyxis_source (language.item, plain_text)
				create table.make_from_pyxis (language.item, file_path)
				assert ("same size", decrypted_table.count = table.count)
				across table as translation loop
					if decrypted_table.has_key (translation.key) then
						assert ("same value", translation.item ~ decrypted_table.found_item)
					else
						assert (translation.key + " found", False)
					end
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "credits.pyx" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := EL_test_data_dir #+ "pyxis/localization"
		end
end