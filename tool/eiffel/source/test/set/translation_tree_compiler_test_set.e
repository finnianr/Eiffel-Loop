note
	description: "Translation tree compiler test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-07 7:33:37 GMT (Monday 7th February 2022)"
	revision: "13"

class
	TRANSLATION_TREE_COMPILER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_LOCALIZATION_TEST
		rename
			check_reflective_locale_texts as test_reflective_locale_texts
		undefine
			new_lio
		end

	EL_CRC_32_TEST_ROUTINES

	EIFFEL_LOOP_TEST_ROUTINES

	EL_SHARED_SINGLETONS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("compile_tree", agent test_compile_tree)
		end

feature -- Tests

	test_compile_tree
		local
			restored_list: EL_TRANSLATION_ITEMS_LIST
			translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]
			restored_table, filled_table: EL_TRANSLATION_TABLE
			locale_en: EL_ENGLISH_DEFAULT_LOCALE_IMP
			locale_table: EL_LOCALE_TABLE; texts: EL_UNINSTALL_TEXTS
		do
			create translations_table.make_size (20)
			do_test ("compile_twice", 2969954864, agent compile_twice, [translations_table])

			lio.put_line ("Checking restore")
			create locale_table.make (Locales_dir)
			across locale_table as language loop
				lio.put_string_field ("language", language.key)
				lio.put_new_line
				create restored_list.make_from_file (language.item)
				restored_list.retrieve

				restored_table := restored_list.to_table (language.key)
				filled_table := translations_table.item (language.key).to_table (language.key)

				assert ("same count", restored_table.count = filled_table.count)
				across restored_table as table loop
					assert ("same value", table.item ~ filled_table [table.key])
				end
			end
			test_reflective_locale_texts

			Singleton_table.remove (locale_table)

			create texts.make
			assert ("has 1 place holder", texts.uninstall_application.occurrences ('%S') = 1)

			create locale_en.make (Work_area_dir)
			assert ("same string", texts.uninstall_application ~ locale_en * "{uninstall-application}")
		end

feature {NONE} -- Implementation

	compile_twice (translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING])
		local
			command: PYXIS_TRANSLATION_TREE_COMPILER
		do
			across 1 |..| 2 as n loop
				lio.put_integer_field ("Run", n.item)
				lio.put_new_line
				create command.make ("", work_area_dir, Locales_dir)
				command.execute
				if n.item = 1 then
					translations_table.merge (command.translations_table)
				end
				lio.put_new_line
			end
		end

	locale_texts_types: TUPLE [
		EL_DAY_OF_WEEK_TEXTS,
		EL_MONTH_TEXTS,
		EL_PASSPHRASE_TEXTS,
		EL_UNINSTALL_TEXTS
	]
		do
			create Result
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<<
				Data_dir + "app-manage/el_uninstall_texts.pyx",
				Data_dir + "base/el_month_texts.pyx",
				Data_dir + "base/el_day_of_week_texts.pyx"
			>>)
		end

feature {NONE} -- Constants

	Locales_dir: DIR_PATH
		once
			Result := Work_area_dir #+ "locales"
		end

	Data_dir: DIR_PATH
		once
			Result := Eiffel_loop_dir #+ "library/localization"
		end

end