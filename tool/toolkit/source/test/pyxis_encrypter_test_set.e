note
	description: "Test class ${PYXIS_ENCRYPTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:23:29 GMT (Sunday 4th May 2025)"
	revision: "10"

class
	PYXIS_ENCRYPTER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			Data_dir as Localization_dir,
			Plain_text as Type_plain_text
		end

	EL_MODULE_ENCRYPTION

	SHARED_DATA_DIRECTORIES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["execute", agent test_execute]
			>>)
		end

feature -- Tests

	test_execute
		local
			table, decrypted_table: EL_TRANSLATION_TABLE;
			decrypted_pyxis_table, pyxis_table: EL_PYXIS_ML_TRANSLATION_TABLE
			plain_text: STRING; aes_encrypter: EL_AES_ENCRYPTER
			pyxis_encrypter: PYXIS_ENCRYPTER; file_path: FILE_PATH
		do
			file_path := file_list.first_path
			create aes_encrypter.make ("secret", 128)
			create pyxis_encrypter.make (file_path, create {FILE_PATH}, aes_encrypter)
			pyxis_encrypter.execute
			aes_encrypter.reset
			plain_text := Encryption.plain_pyxis (pyxis_encrypter.output_path, aes_encrypter)

			create decrypted_pyxis_table.make_from_source (plain_text)
			create pyxis_table.make_from_file (file_path)

			across << "en", "de" >> as language loop
				create decrypted_table.make_from_table (language.item, decrypted_pyxis_table)
				create table.make_from_table (language.item, pyxis_table)

				assert ("same size", decrypted_table.count = table.count)
				across table as translation loop
					if decrypted_table.has_key (translation.key) then
						assert ("same value", translation.item ~ decrypted_table.found_item)
					else
						assert_32 (translation.key + " found", False)
					end
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Localization_dir + "credits.pyx" >>)
		end

feature {NONE} -- Constants

	Localization_dir: DIR_PATH
		once
			Result := Data_dir.pyxis #+ "localization"
		end
end