note
	description: "Test set for ${EL_EXTENDED_READABLE_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 19:18:39 GMT (Sunday 6th April 2025)"
	revision: "3"

class
	EXTENDED_READABLE_ZSTRING_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["append_substring_to_string_32", agent test_append_substring_to_string_32],
				["append_substring_to_string_8",	 agent test_append_substring_to_string_8],
				["ascii_query",						 agent test_ascii_query],
				["character_counts",					 agent test_character_counts],
				["is_variable_reference",			 agent test_is_variable_reference],
				["same_string",						 agent test_same_string],
				["word_count",							 agent test_word_count]
			>>)
		end

feature -- Tests

	test_append_substring_to_string_32
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_append_substring_to_string_32
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I).append_substring_to_string_32,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.append_substring_to_special_32,
				covers/{EL_STRING_GENERAL_ROUTINES_I}.super_readable_general
			]"
		local
			test: IMMUTABLE_STRING_TEST; str_32: STRING_32
		do
			create str_32.make_filled ('-', 3)
			str_32 [3] := ' '

			across Text.lines_32 as line loop
				test := new_immutable_test (line.item)
				if attached test.word_intervals as intervals then
					str_32.keep_head (3)
					intervals.go_i_th (2) -- go to 2nd word
					str_32.append_substring (line.item, intervals.item_lower, intervals.item_upper)
					test.append_substring_to_string_32 (str_32, intervals)
				end
			end
		end

	test_append_substring_to_string_8
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_append_substring_to_string_8
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I).append_substring_to_string_8,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.append_substring_to_special_8,
				covers/{EL_STRING_GENERAL_ROUTINES_I}.super_readable_general
			]"
		local
			test: IMMUTABLE_STRING_TEST; str_8: STRING_8
		do
			create str_8.make_filled ('-', 3)
			str_8 [3] := ' '

			across Text.latin_1_list as list loop
				test := new_immutable_test (list.item)
				if attached test.word_intervals as intervals then
					str_8.keep_head (3)
					intervals.go_i_th (2) -- go to 2nd word
					str_8.append_substring (list.item, intervals.item_lower, intervals.item_upper)
					test.append_substring_to_string_8 (str_8, intervals)
				end
			end
		end

	test_ascii_query
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_ascii_query
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I).is_ascii,
				covers/{EL_EXTENDED_READABLE_STRING_I).is_ascii_substring,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.all_ascii_in_range,
				covers/{EL_CHARACTER_X_ROUTINES}.is_ascii_area
			]"
		local
			test: IMMUTABLE_STRING_TEST; str_32: STRING_32; is_ascii_interval: BOOLEAN
		do
			across Text.lines_32 as line loop
				test := new_immutable_test (line.item)
				if attached test.word_intervals as interval then
					from interval.start until interval.after loop
						str_32 := line.item.substring (interval.item_lower, interval.item_upper)
						is_ascii_interval := across str_32 as uc all uc.item.code <= {ASCII}.Last_ascii end
						test.is_ascii_substring (interval, is_ascii_interval)

						test.set_substrings (interval.item_lower, interval.item_upper)
						test.is_ascii (is_ascii_interval)

						interval.forth
					end
				end
			end
			if attached padded_8 ((0xA9).to_character_8) as non_ascii_padding then
				assert ("not all ascii characters", not super_8 (non_ascii_padding).is_ascii)
			end
			assert ("all ascii characters", super_8 (padded_8 ('%T')).is_ascii)
		end

	test_character_counts
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_character_counts
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I}.leading_occurrences,
				covers/{EL_EXTENDED_READABLE_STRING_I}.leading_white_count,
				covers/{EL_EXTENDED_READABLE_STRING_I}.trailing_white_count,
				covers/{EL_EXTENDED_READABLE_STRING_I}.latin_1_count,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.leading_occurrences,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.leading_white_count,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.trailing_white_count,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.latin_1_count
			]"
		local
			character_string: STRING_32; result_ok: BOOLEAN; character_32: CHARACTER_32
			z_str: ZSTRING
		do
			character_string := "%T - -"; character_string.extend (Text.Euro_symbol)
			assert ("6 characters", character_string.count = 6)
			across character_string as character loop
					character_32 := character.item
					if attached padded_32 (character_32) as str then
						z_str := str
						inspect character.cursor_index
							when 1 then
								assert ("is tab", character_32 = '%T')
								if super_readable (z_str).leading_occurrences (character_32) = 1 then
									result_ok := super_readable_32 (str).leading_occurrences (character_32) = 1
								else
									failed ("1 leading tab")
								end
							when 2 then
								assert ("is space", character_32 = ' ')
								if super_readable (z_str).leading_white_count = 1 then
									result_ok := super_readable_32 (str).leading_white_count = 1
								else
									failed ("1 leading space")
								end
							when 3 then
								assert ("is hyphen", character_32 = '-')
								if super_readable (z_str).leading_white_count = 0 then
									result_ok := super_readable_32 (str).leading_white_count = 0
								else
									failed ("0 leading space")
								end
							when 4 then
								assert ("is space", character_32 = ' ')
								if super_readable (z_str).trailing_white_count = 1 then
									result_ok := super_readable_32 (str).trailing_white_count = 1
								else
									failed ("1 trailing space")
								end
							when 5 then
								assert ("is hyphen", character_32 = '-')
								if super_readable (z_str).trailing_white_count = 0 then
									result_ok := super_readable_32 (str).trailing_white_count = 0
								else
									failed ("0 trailing space")
								end
							when 6 then
								assert ("is euro", character_32 = Text.Euro_symbol)
								if super_readable (z_str).latin_1_count = 3 then
									result_ok := super_readable_32 (str).latin_1_count = 3
								else
									failed ("3 latin-1 characters")
								end
						else
						end
					end
			end
		end

	test_is_variable_reference
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_is_variable_reference
		local
			is_variable_reference: ARRAY [BOOLEAN]; i: INTEGER
		do
			is_variable_reference := << True, False, True, False >>
			across new_string_type_list ("$index, $in-dex, ${index}, index") as csv_list loop
				across Convert_string.split_list (csv_list.item, ',', {EL_SIDE}.Left) as list loop
					if attached list.item as str and then attached super_readable_general (str) as super_str then
						i := list.cursor_index
						assert ("expected result", super_str.is_variable_reference = is_variable_reference [i])
					end
				end
			end
		end

	test_same_string
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_same_string
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I).same_string,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.same_string
			]"
		local
			index_space: INTEGER
		do
			across Text.lines_32 as line loop
				across new_tests_with_immutable as list loop
					if attached list.item as test and then attached line.item as str_32 then
						test.set (str_32)
						index_space := str_32.last_index_of (' ', str_32.count)
						test.set_substrings (index_space + 1, str_32.count)
						test.same_string
					end
				end
			end
		end

	test_word_count
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_word_count
		note
			testing: "[
				covers/{EL_READABLE_STRING_X_ROUTINES}.word_count
			]"
		local
			string: STRING; word_count: INTEGER
		do
			string := "one; ${index} two%T patrick's"
			across 1 |..| 2 as n loop
				across new_string_type_list (string) as type_list loop
					across type_list as list loop
						if attached list.item as l_text then
							word_count := super_readable_general (l_text).word_count (True)
							assert ("3 words", word_count = 3)
						end
					end
				end
				string.prepend ("%N "); string.append ("%N ")
			end
		end
end