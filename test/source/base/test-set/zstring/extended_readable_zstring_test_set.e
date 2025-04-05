note
	description: "Test set for ${EL_EXTENDED_READABLE_ZSTRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 16:21:09 GMT (Friday 4th April 2025)"
	revision: "1"

class
	EXTENDED_READABLE_ZSTRING_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_STRING_32_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["append_substring_to_string_32", agent test_append_substring_to_string_32],
				["append_substring_to_string_8",	 agent test_append_substring_to_string_8],
				["is_ascii_substring",				 agent test_is_ascii_substring],
				["same_string",						 agent test_same_string]
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

	test_is_ascii_substring
		-- EXTENDED_READABLE_ZSTRING_TEST_SET.test_is_ascii_substring
		note
			testing: "[
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
						interval.forth
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

end