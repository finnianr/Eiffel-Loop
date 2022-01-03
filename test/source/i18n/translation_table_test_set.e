note
	description: "Translation table test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "12"

class
	TRANSLATION_TABLE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("reading_from_file", agent test_reading_from_file)
			eval.call ("reading_from_source", agent test_reading_from_source)
		end

feature -- Tests

	test_reading_from_file
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
			create Result.make_from_pyxis_source (language, File_system.plain_text (file_path))
		end

	test_reading (new_table: FUNCTION [STRING, FILE_PATH, EL_TRANSLATION_TABLE])
		local
			pyxis_file_path: FILE_PATH; table: EL_TRANSLATION_TABLE
		do
			across << "credits", "phrases", "words" >> as name loop
				pyxis_file_path := Localization_dir + (name.item + ".pyx")
				log.put_labeled_string ("Localization", pyxis_file_path.base)
				log.put_new_line
				across << "en", "de" >> as language loop
					table := new_table (language.item, pyxis_file_path)
					across table as translation loop
						log.put_string_field_to_max_length (translation.key, translation.item, 200)
						log.put_new_line
					end
				end
			end
		end

feature {NONE} -- Constants

	Localization_dir: DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_tuple (["pyxis", "localization"])
		end

end
