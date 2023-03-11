note
	description: "Test class [$source CLASS_RENAMING_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 12:13:39 GMT (Friday 10th March 2023)"
	revision: "10"

class
	CLASS_RENAMING_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["renaming", agent test_renaming]
			>>)
		end

feature -- Tests

	test_renaming
		local
			command: CLASS_RENAMING_COMMAND; digest_table: like new_file_digest_table
			string_8_counter: EL_SPLIT_ON_STRING [STRING]
			manifest: SOURCE_MANIFEST
		do
			digest_table := new_file_digest_table
			create manifest.make_from_file (Manifest_path)
			manifest.read_source_trees
			
			create command.make (manifest, "STRING", "STRING_8")
			command.execute

			file_list.find_first_base ("el_text_item_translations_table.e")
			assert ("found EL_TEXT_ITEM_TRANSLATIONS_TABLE", file_list.found)
			create string_8_counter.make (File.plain_text (file_list.path), "STRING_8")
			assert ("11 items counted", string_8_counter.count - 1 = 11)

			across file_list as list loop
				if attached list.item as source_path
					and then not source_path.base.starts_with_general ("el_text_item")
				then
					assert_same_digest_hexadecimal (source_path, digest_table [source_path].to_hex_string)
				end
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources/utf-8"
		end
end