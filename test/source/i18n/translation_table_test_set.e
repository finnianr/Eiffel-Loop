note
	description: "Translation table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-19 10:59:48 GMT (Sunday 19th March 2023)"
	revision: "21"

class
	TRANSLATION_TABLE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET
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
				["reading_from_file", agent test_reading_from_file],
				["reading_from_source", agent test_reading_from_source]
			>>)
		end

feature -- Tests

	test_reading_from_file
		-- TRANSLATION_TABLE_TEST_SET.test_reading_from_file
		do
			do_test ("test_reading_from_file", 459241925, agent test_reading, [agent new_table_from_file])
		end

	test_reading_from_source
		note
			testing: "covers/{EL_PYXIS_PARSER}.parse_from_string"
		do
			do_test ("test_reading_from_source", 3542890563, agent test_reading, [agent new_table_from_source])
		end

feature {NONE} -- Implementation

	new_table_from_file (language: STRING; file_path: FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis (language, file_path)
		end

	new_table_from_source (language: STRING; file_path: FILE_PATH): EL_TRANSLATION_TABLE
		do
			create Result.make_from_pyxis_source (language, File.plain_text (file_path))
		end

	test_reading (new_table: FUNCTION [STRING, FILE_PATH, EL_TRANSLATION_TABLE])
		local
			pyxis_file_path: FILE_PATH; table: EL_TRANSLATION_TABLE
		do
			across << "credits", "phrases", "words" >> as name loop
				pyxis_file_path := Localization_dir + (name.item + ".pyx")
				lio.put_labeled_string ("Localization", pyxis_file_path.base)
				lio.put_new_line
				across << "en", "de" >> as language loop
					table := new_table (language.item, pyxis_file_path)
					across table as translation loop
						lio.put_curtailed_string_field (translation.key, translation.item, 200)
						lio.put_new_line
					end
				end
			end
		end

feature {NONE} -- Constants

	Localization_dir: DIR_PATH
		once
			Result := Dev_environ.EL_test_data_dir.joined_dir_tuple (["pyxis", "localization"])
		end

end