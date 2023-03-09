note
	description: "Test commands conforming to [$source SOURCE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-09 16:01:41 GMT (Thursday 9th March 2023)"
	revision: "8"

class
	EIFFEL_SOURCE_COMMAND_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_named (<<
				["codebase_statistics", agent test_codebase_statistics],
				["find_and_replace", agent test_find_and_replace],
				["space_cleaner", agent test_space_cleaner]
			>>)
		end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("codebase_statistics", agent test_codebase_statistics)
			eval.call ("find_and_replace", agent test_find_and_replace)
			eval.call ("space_cleaner", agent test_space_cleaner)
		end

feature -- Tests

	test_codebase_statistics
		local
			command: CODEBASE_STATISTICS_COMMAND
		do
			create command.make (Manifest_path, create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute
			assert ("28 classes", command.class_count = 30)
			assert ("10202 words", command.word_count = 10226)
			assert ("Total size 96665 bytes", command.byte_count = 96973)
		end

	test_find_and_replace
		local
			command: FIND_AND_REPLACE_COMMAND; replace_count: INTEGER
			plain_text_lines: like File.plain_text_lines
		do
			create command.make (Manifest_path, "INTEGER =", Integer_32_type)
			command.execute
			across file_list as list loop
				plain_text_lines := File.plain_text_lines (list.item)
				if plain_text_lines.target.has_substring (Integer_32_type) then
					across plain_text_lines as line loop
						replace_count := replace_count + line.item.has_substring (Integer_32_type).to_integer
					end
				end
				if list.item.base ~ Encoding_sample.utf_8 or list.item.base ~ Encoding_sample.latin_1 then
					assert ("has replacement", File.plain_text (list.item).has_substring (Integer_32_type))
				end
			end
			assert ("24 replacements", replace_count = 24)
			assert_valid_encodings
		end

	test_space_cleaner
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_space_cleaner
		local
			cleaner: SOURCE_LEADING_SPACE_CLEANER
		do
			create cleaner.make (Manifest_path)
			cleaner.execute
			if attached cleaner.edited_list as list
				and then list.count = 1 and then list.first_path.base_matches ("ev_pixmap_imp_drawable", False)
			then
				assert_same_digest (list.first_path, "BGfhfW0ucYUTtNmjtmbBPQ==")
			else
				assert ("expected only ev_pixmap_imp_drawable", False)
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Integer_32_type: STRING = "INTEGER_32 ="

end