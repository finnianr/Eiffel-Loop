note
	description: "Translation tree compiler test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-24 12:26:12 GMT (Monday 24th August 2020)"
	revision: "2"

class
	TRANSLATION_TREE_COMPILER_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_SHARED_LOCALE_TABLE
		redefine
			Locales_dir
		end


feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("compile", agent test_compile)
		end

feature -- Tests

	test_compile
		do
			do_test ("compile_tree", 1258919698, agent compile_tree, [])
		end

feature {NONE} -- Implementation

	compile_tree
			--
		local
			command: PYXIS_TRANSLATION_TREE_COMPILER
			restored_list: EL_TRANSLATION_ITEMS_LIST
			translations_table: EL_HASH_TABLE [EL_TRANSLATION_ITEMS_LIST, STRING]
			restored_table, filled_table: EL_TRANSLATION_TABLE
			translation, years: ZSTRING; locale: EL_LOCALE_IMP
		do
			across 1 |..| 2 as n loop
				lio.put_integer_field ("Run", n.item)
				lio.put_new_line
				create command.make (work_area_data_dir, Locales_dir)
				command.execute
				if n.item = 1 then
					translations_table := command.translations_table
				end
				lio.put_new_line
			end
			lio.put_line ("Checking restore")
			across locale_table as language loop
				lio.put_string_field ("language", language.key)
				lio.put_new_line
				create restored_list.make_from_file (language.item)
				restored_list.retrieve

				restored_table := restored_list.to_table (language.key)
				filled_table := translations_table.item (language.key).to_table (language.key)

				assert ("same count", restored_table.count = filled_table.count)
				across restored_table as table loop
					translation := table.item
					if translation.has ('%N') then
						lio.put_string_field_to_max_length (table.key, translation, 60)
					else
						lio.put_labeled_string (table.key, translation)
					end
					lio.put_new_line
					assert ("same value", translation ~ filled_table [table.key])
				end
			end

			create locale.make ("en", "en")
			across 1 |..| 2 as n loop
				years := Years_template #$ [n.item]
				if n.item = 2 then
					years.append_character ('s')
				end
				assert ("same string", locale.quantity_translation ("{for-n-years}", n.item) ~ years)
			end
		end

feature {NONE} -- Constants

	Source_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("pyxis/localization")
		end

	Locales_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_tuple ([Locales_dir_name])
		end

	Years_template: ZSTRING
		once
			Result := "for %S year"
		end

end