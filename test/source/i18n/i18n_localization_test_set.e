note
	description: "Translation table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 9:39:09 GMT (Thursday 18th July 2024)"
	revision: "27"

class
	I18N_LOCALIZATION_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
		undefine
			new_lio
		end

	EL_LOCALIZATION_TEST
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["language_set_reader",		 agent test_language_set_reader],
				["reading_from_file",		 agent test_reading_from_file],
				["reading_from_source",		 agent test_reading_from_source],
				["reflective_locale_texts", agent test_reflective_locale_texts]
			>>)
		end

feature -- Tests

	test_language_set_reader
		note
			testing: "[
				covers/{EL_LANGUAGE_SET_READER}.make_from_file
			]"
		local
			reader: EL_LANGUAGE_SET_READER
		do
			create reader.make_from_file (Localization_dir + "credits.pyx")
			assert ("2 languages", reader.language_set.count = 2)
			across << "en", "de" >> as list loop
				assert ("has language", reader.language_set.has (list.item))
			end
		end

	test_reading_from_file
		-- TRANSLATION_TABLE_TEST_SET.test_reading_from_file
		do
			do_test ("test_reading_from_file", 3580702002, agent test_reading, [agent new_table_from_file])
		end

	test_reading_from_source
		note
			testing: "covers/{EL_PYXIS_PARSER}.parse_from_string"
		do
			do_test ("test_reading_from_source", 3766536358, agent test_reading, [agent new_table_from_source])
		end

	test_reflective_locale_texts
		-- I18N_LOCALIZATION_TEST_SET.test_reflective_locale_texts
		do
			check_reflective_locale_texts
		end

feature {NONE} -- Factory

	new_table_from_file (language: STRING; file_path: FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis (language, file_path)
		end

	new_table_from_source (language: STRING; file_path: FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis_source (language, File.plain_text (file_path))
		end

feature {NONE} -- Implementation

	locale_texts_types: TUPLE [
		EL_DAY_OF_WEEK_TEXTS,
		EL_CURRENCY_TEXTS,
		EL_MONTH_TEXTS,

		EL_PHRASE_TEXTS,
		EL_PASSPHRASE_ATTRIBUTES,
		EL_PASSPHRASE_TEXTS,
		EL_SYMBOL_TEXTS,

		EL_UNINSTALL_TEXTS,
		EL_WORD_TEXTS
	]
		do
			create Result
		end

	test_reading (new_table: FUNCTION [STRING, FILE_PATH, EL_TRANSLATION_TABLE])
		local
			pyxis_file_path: FILE_PATH; table: EL_TRANSLATION_TABLE
		do
			across << "credits", "phrases", "words" >> as name loop
				pyxis_file_path := Localization_dir + (name.item + ".pyx")
				lio.put_labeled_string ("Localization", pyxis_file_path.base)
				lio.put_new_line
				across << English_code, "de" >> as language loop
					table := new_table (language.item, pyxis_file_path)
					across table as translation loop
						lio.put_curtailed_string_field (translation.key, translation.item, 200)
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Constants

	English_code: STRING = "en"

	Localization_dir: DIR_PATH
		once
			Result := Dev_environ.EL_test_data_dir.joined_dir_tuple (["pyxis", "localization"])
		end

end