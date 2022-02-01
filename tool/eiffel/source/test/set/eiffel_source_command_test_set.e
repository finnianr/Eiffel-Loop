note
	description: "Test commands conforming to [$source SOURCE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-01 10:46:32 GMT (Tuesday 1st February 2022)"
	revision: "2"

class
	EIFFEL_SOURCE_COMMAND_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("codebase_statistics", agent test_codebase_statistics)
			eval.call ("find_and_replace", agent test_find_and_replace)
		end

feature -- Tests

	test_codebase_statistics
		local
			command: CODEBASE_STATISTICS_COMMAND
		do
			create command.make (Manifest_path, create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute
			assert ("28 classes", command.class_count = 28)
			assert ("10202 words", command.word_count = 10202)
			assert ("Total size 96665 bytes", command.byte_count = 96665)
		end

	test_find_and_replace
		local
			command: FIND_AND_REPLACE_COMMAND; replace_count: INTEGER
			plain_text_lines: like File_system.plain_text_lines
		do
			create command.make (Manifest_path, "INTEGER =", Integer_32_type)
			command.execute
			across file_list as list loop
				plain_text_lines := File_system.plain_text_lines (list.item)
				if plain_text_lines.target.has_substring (Integer_32_type) then
					across plain_text_lines as line loop
						replace_count := replace_count + line.item.has_substring (Integer_32_type).to_integer
					end
				end
				if list.item.base ~ Encoding_sample.utf_8 or list.item.base ~ Encoding_sample.latin_1 then
					assert ("has replacement", File_system.plain_text (list.item).has_substring (Integer_32_type))
				end
			end
			assert ("24 replacements", replace_count = 24)
			assert_valid_encodings
		end

feature {NONE} -- Constants

	Integer_32_type: STRING = "INTEGER_32 ="

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

end