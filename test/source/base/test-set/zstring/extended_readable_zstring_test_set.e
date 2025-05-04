note
	description: "Test set for ${EL_EXTENDED_READABLE_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 8:39:13 GMT (Sunday 4th May 2025)"
	revision: "13"

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
				["bracketed",							 agent test_bracketed],
				["character_counts",					 agent test_character_counts],
				["filtered",							 agent test_filtered],
				["last_word_end_index",				 agent test_last_word_end_index],
				["is_eiffel_name",					 agent test_is_eiffel_name],
				["is_variable_reference",			 agent test_is_variable_reference],
				["occurrences_in_bounds",			 agent test_occurrences_in_bounds],
				["replaced_identifier",				 agent test_replaced_identifier],
				["same_string",						 agent test_same_string],
				["set_substring_lower",				 agent test_set_substring_lower],
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

	test_bracketed
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_bracketed
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I}.bracketed_substring,
				covers/{EL_EXTENDED_READABLE_STRING_I}.matching_bracket_index,
				covers/{EL_CHARACTER_X_ROUTINES}.right_bracket_index
			]"
		local
			name, name_2: IMMUTABLE_STRING_8; type_array: ARRAY [TYPE [ANY]]
			content: READABLE_STRING_8
		do
			type_array := << {ARRAYED_LIST [INTEGER]}, {ARRAYED_LIST [CELL [INTEGER]]} >>
			across type_array as array loop
				across << False, True >> as is_last loop
					name := array.item.name
					if is_last.item then
						content := super_readable_8 (name).bracketed_last ('[')
						name_2 := ({INTEGER}).name
					else
						content := super_readable_8 (name).bracketed ('[')
						name_2 := if array.is_first then ({INTEGER}).name else ({CELL [INTEGER]}).name end
					end
					assert ("content is immutable", content.is_immutable)
					assert_same_string (Void, content, name_2)
				end
			end
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
								if super_z (z_str).leading_occurrences (character_32) = 1 then
									result_ok := super_readable_32 (str).leading_occurrences (character_32) = 1
								else
									failed ("1 leading tab")
								end
							when 2 then
								assert ("is space", character_32 = ' ')
								if super_z (z_str).leading_white_count = 1 then
									result_ok := super_readable_32 (str).leading_white_count = 1
								else
									failed ("1 leading space")
								end
							when 3 then
								assert ("is hyphen", character_32 = '-')
								if super_z (z_str).leading_white_count = 0 then
									result_ok := super_readable_32 (str).leading_white_count = 0
								else
									failed ("0 leading space")
								end
							when 4 then
								assert ("is space", character_32 = ' ')
								if super_z (z_str).trailing_white_count = 1 then
									result_ok := super_readable_32 (str).trailing_white_count = 1
								else
									failed ("1 trailing space")
								end
							when 5 then
								assert ("is hyphen", character_32 = '-')
								if super_z (z_str).trailing_white_count = 0 then
									result_ok := super_readable_32 (str).trailing_white_count = 0
								else
									failed ("0 trailing space")
								end
							when 6 then
								assert ("is euro", character_32 = Text.Euro_symbol)
								if super_z (z_str).latin_1_count = 3 then
									result_ok := super_readable_32 (str).latin_1_count = 3
								else
									failed ("3 latin-1 characters")
								end
						else
						end
					end
			end
		end

	test_filtered
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_filtered
		note
			testing: "covers/{EL_EXTENDED_READABLE_STRING_I}.filtered"
		local
			c: EL_CHARACTER_8_ROUTINES; str:	 STRING
		do
			create str.make_empty
			super_readable_8 (padded_8 ('%T')).filter (agent c.is_a_to_z_lower, str)
			assert ("is abc", str ~ "abc" )
			assert ("trimmed", str.capacity = str.count)
		end

	test_is_eiffel_name
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_is_eiffel_name
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I}.is_eiffel_title,
				covers/{EL_EXTENDED_READABLE_STRING_I}.is_eiffel_lower,
				covers/{EL_EXTENDED_READABLE_STRING_I}.is_eiffel_upper
			]"
		do
			if attached padded_8 ('%T').shared_substring (2, 4) as abc then
			-- test uing immutable string
				assert ("abc", abc.same_string ("abc"))
				assert ("is eiffel lower", super_readable_8 (abc).is_eiffel_lower)
				assert ("is not eiffel upper", not super_readable_8 (abc).is_eiffel_upper)
				assert ("is not eiffel title", not super_readable_8 (abc).is_eiffel_title)
				assert ("is not eiffel title", not super_readable_8 (abc.as_upper).is_eiffel_title)
				assert ("is eiffel title", super_readable_8 ("Abc").is_eiffel_title)
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

	test_last_word_end_index
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_last_word_end_index
		local
			format: STRING; end_index: INTEGER
		do
			format := "yyyy mmm dd"
			end_index := super_8 (format).last_word_end_index (2)
			assert_same_string (Void, format.substring (1, end_index), "yyyy")
		end

	test_occurrences_in_bounds
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_occurrences_in_bounds
		local
			expected_occurrences, occurrences: INTEGER; first: CHARACTER_32
		do
			across Text.lines as line loop
				if attached line.item as str then
					first := str [1]
					occurrences := super_z (str).occurrences_in_bounds (first, 5, str.count - 5)
					inspect line.cursor_index
						when Line_cyrillic, Line_accented, Line_quattro then
							expected_occurrences := 1
						when Line_ascii, Line_latin_1, Line_latin_15, Line_euro then
							expected_occurrences := 0
					else
					end
					assert ("as expected", expected_occurrences = occurrences)
				end
			end
		end

	test_replaced_identifier
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_replaced_identifier
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I).is_identifier_boundary,
				covers/{EL_EXTENDED_READABLE_ZSTRING}.is_identifier_boundary
				covers/{EL_EXTENDED_STRING_GENERAL}.replaced_identifier
			]"
		do
			across new_string_type_list ("has_substring, has, has_8, chase:has:hash") as string_list loop
				if attached string_list.item.split (':') as parts then
					if attached {STRING_GENERAL} parts.first as csv_list
						and then attached parts [2] as old_id
						and then attached parts.last as new_id
						and then attached super_general (csv_list) as str
					then
						assert_same_string (Void, str.replaced_identifier (old_id, new_id), "has_substring, hash, has_8, chase")
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

	test_set_substring_lower
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_set_substring_lower
		note
			testing: "[
				covers/{EL_EXTENDED_STRING_GENERAL}.set_substring_lower,
				covers/{EL_EXTENDED_STRING_GENERAL}.set_substring_upper,
				covers/{EL_EXTENDED_STRING_GENERAL}.put_lower,
				covers/{EL_EXTENDED_STRING_GENERAL}.put_upper
			]"
		local
			string: STRING
		do
			string := "abcd"
			across << {EL_CASE}.Lower, {EL_CASE}.Upper >> as case loop
				if case.item = {EL_CASE}.Lower then
					string.to_upper
				else
					string.to_lower
				end
				across new_string_type_list (string.twin) as type_list loop
					if attached {STRING_GENERAL} type_list.item as str
						and then attached super_general (str) as super
					then
						inspect case.item
							when {EL_CASE}.Lower then
								assert ("upper case", str [2].is_upper)
								super.set_substring_lower (2, 3)
								assert_same_string (Void, str, "AbcD")
								super.put_lower (4)
								assert ("is d", str [4] = 'd')
							when {EL_CASE}.Upper then
								assert ("lower case", str [2].is_lower)
								super.set_substring_upper (2, 3)
								assert_same_string (Void, str, "aBCd")
								super.put_upper (4)
								assert ("is D", str [4] = 'D')
						else
						end
					end
				end
			end
		end

	test_word_count
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_word_count
		note
			testing: "[
				covers/{EL_SPLIT_WORD_INTERVALS}.word_count,
				covers/{EL_SPLIT_WORD_INTERVALS}.fill,
				covers/{EL_EXTENDED_READABLE_STRING_I}.leading_white_count_in_bounds,
				covers/{EL_EXTENDED_READABLE_STRING_I}.trailing_white_count_in_bounds,
				covers/{EL_EXTENDED_READABLE_STRING_I}.leading_white_count_in_bounds,
				covers/{EL_EXTENDED_READABLE_STRING_I}.trailing_white_count_in_bounds,
				covers/{EL_MEASUREABLE_ZSTRING}.leading_white_count_in_bounds,
				covers/{EL_MEASUREABLE_ZSTRING}.trailing_white_count_in_bounds,
				covers/{EL_MEASUREABLE_ZSTRING}.leading_white_count_in_bounds,
				covers/{EL_MEASUREABLE_ZSTRING}.trailing_white_count_in_bounds
			]"
		local
			string: STRING; word_count: INTEGER; word_intervals: EL_SPLIT_WORD_INTERVALS
		do
			create word_intervals.make_empty

			string := "one; ${index} two%T patrick's"
			across 1 |..| 2 as n loop
				across new_string_type_list (string) as type_list loop
					across type_list as list loop
						if attached list.item as l_text then
							word_intervals.fill (l_text)
							word_count := word_intervals.word_count (l_text, True)
							assert ("3 words", word_count = 3)
						end
					end
				end
				string.prepend ("%N "); string.append ("%N ")
			end
		end
end