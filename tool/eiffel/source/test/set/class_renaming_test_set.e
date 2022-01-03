note
	description: "Test class [$source CLASS_RENAMING_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	CLASS_RENAMING_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("renaming", agent test_renaming)
		end

feature -- Tests

	test_renaming
		local
			command: CLASS_RENAMING_COMMAND; digest_table: HASH_TABLE [EL_DIGEST_ARRAY, ZSTRING]
			string_8_counter: EL_SPLIT_ON_STRING [STRING]; name: ZSTRING
		do
			create digest_table.make (3)
			across file_list as list loop
				if list.item.has_extension ("e") then
					digest_table [list.item.base] := Digest.md5_file (list.item)
				end
			end
			across file_list as list loop
				name := list.item.base
				if name.starts_with ("manifest") then
					create command.make (list.item, "STRING", "STRING_8")
					command.execute

				elseif digest_table [name] /~ Digest.md5_file (list.item) then
					assert ("is EL_TEXT_ITEM_TRANSLATIONS_TABLE", name.starts_with_general ("el_text_item"))
					create string_8_counter.make (File_system.plain_text (list.item), "STRING_8")
					assert ("11 items counted", string_8_counter.count - 1 = 11)
				end
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*")
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/utf8-sources"
		end
end