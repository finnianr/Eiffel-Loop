note
	description: "Translation tree compiler test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:11:37 GMT (Monday 5th May 2025)"
	revision: "31"

class
	LOCALE_COMPILER_TEST_SET

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

	EL_CRC_32_TESTABLE

	EL_SHARED_SINGLETONS; SHARED_EIFFEL_LOOP

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["compile_tree", agent test_compile_tree]
			>>)
		end

feature -- Tests

	test_compile_tree
		-- LOCALE_COMPILER_TEST_SET.test_compile_tree
		note
			testing: "[
				covers/{EL_PYXIS_TREE_COMPILER}.execute,
				covers/{EL_PYXIS_LOCALE_COMPILER}.compile,
				covers/{EL_TRANSLATION_ITEMS_LIST}.make_from_file,
				covers/{EL_PYXIS_ML_TRANSLATION_TABLE}.make_from_file
			]"
		local
			restored_list: EL_TRANSLATION_ITEMS_LIST; restored_table, filled_table: EL_TRANSLATION_TABLE
			locale_en: EL_DEFAULT_LOCALE; locale_table: EL_LOCALE_TABLE; texts: EL_UNINSTALL_TEXTS
			translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]
		do
			create translations_table.make (20)
			do_test ("compile_twice", 1517909653, agent compile_twice, [translations_table])

			lio.put_line ("Checking restore")
			create locale_table.make (Locales_dir)
			across locale_table as language loop
				lio.put_string_field ("language", language.key)
				lio.put_new_line
				create restored_list.make_from_file (language.item)

				restored_table := restored_list.to_table (language.key)
				filled_table := translations_table.item (language.key).to_table (language.key)

				assert ("same count", restored_table.count = filled_table.count)
				across restored_table as table loop
					assert ("same value", table.item ~ filled_table [table.key])
				end
			end
			Singleton_table.remove (locale_table)

			create texts.make
			assert ("has 1 place holder", texts.uninstall_application.occurrences ('%S') = 1)

			create locale_en.make_from_location (Work_area_dir)
			assert ("same string", texts.uninstall_application ~ locale_en * "{uninstall_application}")

			test_reflective_locale_texts
		end

feature {NONE} -- Implementation

	compile_twice (translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING])
		local
			command: EL_PYXIS_LOCALE_COMPILER
		do
			across 1 |..| 2 as n loop
				lio.put_integer_field ("Run", n.item)
				lio.put_new_line
				create command.make ("", work_area_dir, Locales_dir)
				if attached command.localization_build_dir_scope (Work_area_dir #+ "localization") as scope then
				-- `command.Localization_build_dir' temporarily changed
					command.execute
					scope.exit
				end
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
		local
			type_list: EL_TUPLE_TYPE_LIST [EL_REFLECTIVE_LOCALE_TEXTS]
			selected_files: EL_STRING_8_LIST
		do
			create type_list.make_from_tuple (locale_texts_types)
			create selected_files.make (type_list.count)
			across type_list as list loop
				selected_files.extend (list.item.name.as_lower + ".pyx")
			end
			Result := OS.filtered_file_list (Data_dir, Filter.base_name_in (selected_files), "*.pyx")
		end

feature {NONE} -- Constants

	Locale_types_count: INTEGER = 4

	Locales_dir: DIR_PATH
		once
			Result := Work_area_dir #+ "locales"
		end

	Data_dir: DIR_PATH
		once
			Result := eiffel_loop_dir #+ "library/localization"
		end

end