note
	description: "Test commands conforming to [$source SOURCE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-09 8:48:24 GMT (Sunday 9th April 2023)"
	revision: "11"

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

feature -- Tests

	test_codebase_statistics
		local
			command: CODEBASE_STATISTICS_COMMAND; assertion_template: ZSTRING
			actual_results, expected_results: EL_ARRAYED_LIST [INTEGER]
		do
			create command.make (Manifest_path, create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute
			create expected_results.make_from_array (<< 31, 10354, 98642 >>)
			create actual_results.make_from_array (<< command.class_count, command.word_count, command.byte_count >>)
			assertion_template := "%S classes %S words. Total size %S bytes"

			assert (assertion_template #$ expected_results.to_tuple, expected_results ~ actual_results)
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
			assert ("expect edition count", cleaner.edited_list.count = Cleaned_file_table.count)
			across cleaner.edited_list as list loop
				assert_same_digest (list.item, Cleaned_file_table [list.item.base_name])
			end
		end

feature {NONE} -- Constants

	Cleaned_file_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["ev_pixmap_imp_drawable", "BGfhfW0ucYUTtNmjtmbBPQ=="],
				["el_x11_extensions_api", "K1NL9HUytsKAAorC63jBiA=="]
			>>)
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Integer_32_type: STRING = "INTEGER_32 ="

end