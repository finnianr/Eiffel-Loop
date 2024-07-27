note
	description: "Translation table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 18:59:34 GMT (Saturday 27th July 2024)"
	revision: "30"

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

	EL_MODULE_PYXIS

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
				["reading_from_xml",			 agent test_reading_from_xml],
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
		-- I18N_LOCALIZATION_TEST_SET.test_reading_from_file
		note
			testing: "[
				covers/{EL_TRANSLATION_TABLE}.make_from_pyxis,
				covers/{EL_PYXIS_PARSER}.parse_from_string
			]"
		do
			do_test ("test_reading_from_file", 1457501396, agent test_reading, [agent new_table_from_file])
		end

	test_reading_from_source
		-- I18N_LOCALIZATION_TEST_SET.test_reading_from_source
		note
			testing: "[
				covers/{EL_TRANSLATION_TABLE}.make_from_pyxis_source,
				covers/{EL_PYXIS_PARSER}.parse_from_string
			]"
		do
			do_test ("test_reading_from_source", 812988386, agent test_reading, [agent new_table_from_source])
		end

	test_reading_from_xml
		-- I18N_LOCALIZATION_TEST_SET.test_reading_from_xml
		note
			testing: "covers/{EL_TRANSLATION_TABLE}.make_from_xdoc"
		do
			do_test ("test_reading_from_xml", 2525472084, agent test_reading, [agent new_table_from_xml])
		end

	test_reflective_locale_texts
		-- I18N_LOCALIZATION_TEST_SET.test_reflective_locale_texts
		do
			check_reflective_locale_texts
		end

feature {NONE} -- Factory

	new_table_from_file (file_path: FILE_PATH): EL_PYXIS_ML_TRANSLATION_TABLE
		do
			create Result.make_from_file (file_path)
		end

	new_table_from_source (file_path: FILE_PATH): EL_PYXIS_ML_TRANSLATION_TABLE
		do
			create Result.make_from_source (File.plain_text (file_path))
		end

	new_table_from_xml (file_path: FILE_PATH): EL_XML_ML_TRANSLATION_TABLE
		do
			create Result.make_from_source (Pyxis.to_utf_8_xml (file_path))
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
		EL_WORD_TEXTS,
		TEST_PHRASES_TEXT
	]
		do
			create Result
		end

	substituted_quantity (language: STRING; table: EL_TRANSLATION_TABLE; key: ZSTRING): ZSTRING
		local
			l_locale: EL_LOCALE; n: INTEGER
		do
			create l_locale.make_with_table (language, table)
			if key.has ('>') then
				n := 10
			else
				n := 1
			end
			Result := l_locale.quantity_translation (Key_for_n_years, n)
		end

	test_reading (new_table: FUNCTION [FILE_PATH, EL_MULTI_LANGUAGE_TRANSLATION_TABLE])
		local
			pyxis_file_path: FILE_PATH; table: EL_TRANSLATION_TABLE
		do
			across << "credits", "words", "phrases" >> as name loop
				pyxis_file_path := Localization_dir + (name.item + ".pyx")
				lio.put_labeled_string ("Pyxis configuration file", pyxis_file_path.base)
				lio.tab_right
				lio.put_new_line
				across << locale.default_language, "de" >> as language loop
					lio.put_line ("lang = " + language.item)
					create table.make_from_table (language.item, new_table (pyxis_file_path))
					across table as translation loop
						lio.put_curtailed_string_field (translation.key, translation.item, 200)
						if translation.key.starts_with (Key_for_n_years) then
							lio.put_character (' ')
							lio.put_line (substituted_quantity (language.item, table, translation.key))
						else
							lio.put_new_line
						end
					end
					lio.put_new_line
				end
				lio.tab_left
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	English_code: STRING = "en"

	Key_for_n_years: ZSTRING
		once
			Result := "{for_n_years}"
		end

	Locale_types_count: INTEGER = 10

	Localization_dir: DIR_PATH
		once
			Result := Dev_environ.EL_test_data_dir.joined_dir_tuple (["pyxis", "localization"])
		end

end