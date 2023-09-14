note
	description: "Test commands conforming to [$source SOURCE_MANIFEST_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-14 17:05:30 GMT (Thursday 14th September 2023)"
	revision: "18"

class
	EIFFEL_SOURCE_COMMAND_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		redefine
			make
		end

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["class_word_reader",	agent test_class_word_reader],
				["codebase_statistics",	agent test_codebase_statistics],
				["find_and_replace",		agent test_find_and_replace],
				["space_cleaner",			agent test_space_cleaner]
			>>)
		end

feature -- Tests

	test_class_word_reader
		note
			testing: "[
				covers/{EIFFEL_SOURCE_READER}.make
			]"
		local
			analyzer: TEST_SOURCE_READER; hexadecimal_count, integer_count: INTEGER
			number: STRING; char_string: ZSTRING
		do
--			create analyzer.make (Data_dir + "utf-8/test_el_astring.e")
			create analyzer.make (Data_dir + "utf-8/el_iso_8859_10_codec.e")
			assert ("101 comments", analyzer.comment_list.count = 101)
			assert_same_string ("Access comment", analyzer.comment_list.first, "-- Access")

			if attached analyzer.numeric_constant_list as numeric_list then
				assert ("161 numeric constants", numeric_list.count = 161)
				assert_same_string ("first number", numeric_list.first, "10")
				assert_same_string ("last number", numeric_list.last, "0xFF")

				across analyzer.numeric_constant_list as list loop
					number := list.item
					if number.is_natural then
						integer_count := integer_count + 1

					elseif number.starts_with ("0x") then
						hexadecimal_count := hexadecimal_count + 1
					end
				end
			end
			assert ("total numbers is 161", integer_count + hexadecimal_count = 161)

			if attached analyzer.keyword_list as keyword_list then
				assert ("total keywords is 169", keyword_list.count = 169)
				assert_same_string ("first keyword", keyword_list.first, "note")
				assert_same_string ("last keyword", keyword_list.last, "end")
			end
			if attached analyzer.identifier_list as identifier_list then
				assert ("total identifiers is 59", identifier_list.count = 59)
				assert_same_string ("first identifier", identifier_list.first, "description")
				assert_same_string ("last identifier", identifier_list.last, "single_byte_unicode_chars")
			end
			if attached analyzer.quoted_character_list as quoted_character_list then
				assert ("total quoted characters is 95", quoted_character_list.count = 95)
				across << quoted_character_list.first, quoted_character_list.last >> as str loop
					create char_string.make_from_utf_8 (str.item)
					if char_string.count = 1 then
						inspect str.cursor_index
							when 1 then
								assert ("is NBSP", char_string [1].natural_32_code = 0xA0)

							when 2 then
								assert ("Greenlandic Kra", char_string [1] = 'ĸ')
						else
						end
					else
						failed ("Is a single character")
					end
				end
			end
		end

	test_codebase_statistics
		-- EIFFEL_SOURCE_COMMAND_TEST_SET.test_codebase_statistics
		local
			command: CODEBASE_STATISTICS_COMMAND; assertion_template: ZSTRING
			actual_results, expected_results: EL_ARRAYED_LIST [INTEGER]
		do
			create command.make (Manifest_path)
			command.execute
			create expected_results.make_from_array (<< 32, 10424, 99488 >>)
			create actual_results.make_from_array (<< command.class_count, command.word_count, command.byte_count >>)
			assertion_template := "%S classes %S words. Total size %S bytes"

			if expected_results /~ actual_results then
				lio.put_labeled_string ("Actual", assertion_template #$ actual_results.to_tuple)
				lio.put_new_line
				lio.put_labeled_string ("Expected", assertion_template #$ expected_results.to_tuple)
				lio.put_new_line
				failed ("same class count, word count etc")
			end
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

feature {NONE} -- Implementation

	list_has (list: ARRAYED_LIST [IMMUTABLE_STRING_8]; str: STRING): BOOLEAN
		do
			Immutable_8.set_item (str.area, 0, str.count)
			Result := list.has (Immutable_8.item)
		end

feature {NONE} -- Constants

	Cleaned_file_table: EL_HASH_TABLE [STRING, STRING]
		once
			create Result.make (<<
				["ev_pixmap_imp_drawable",	"BGfhfW0ucYUTtNmjtmbBPQ=="],
				["el_x11_extensions_api",	"K1NL9HUytsKAAorC63jBiA=="]
			>>)
		end

	Data_dir: DIR_PATH
		once
			Result := "test-data/sources"
		end

	Integer_32_type: STRING = "INTEGER_32 ="

end