note
	description: "Testing ${EL_COMPARABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 7:57:10 GMT (Tuesday 27th August 2024)"
	revision: "6"

class
	ZSTRING_COMPARABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["ends_with",					  agent test_ends_with],
				["floating_string",			  agent test_floating_string],
				["same_caseless_characters", agent test_same_caseless_characters],
				["same_characters",			  agent test_same_characters],
				["starts_with",				  agent test_starts_with]
			>>)
		end

feature -- Tests

	test_ends_with
		-- ZSTRING_COMPARABLE_TEST_SET.test_ends_with
		note
			testing: "[
				covers/{EL_COMPARABLE_ZSTRING}.ends_with,
				covers/{EL_COMPARABLE_ZSTRING}.ends_with_character,
				covers/{EL_TRANSFORMABLE_ZSTRING}.remove_tail,
				covers/{EL_SUBSTRING_32_ARRAY}.same_substring
			]"
		local
			test: STRING_TEST; assertion_OK: STRING
			index, start_index, end_index: INTEGER
		do
			across Text.lines as line loop
				create test.make (line.item)
				if attached test.word_intervals as list then
					from list.start until list.is_empty loop
						start_index := list.item_lower; end_index := list.last_upper
						test.set_substrings (start_index, end_index)
						assert ("ends_with OK", test.ends_with)
						start_index := start_index - 1
						if test.s_32.valid_index (start_index) then
							test.set_substrings (start_index, end_index)
							assert ("ends_with OK", test.ends_with)
						end
						list.remove
					end
				end
			end
		end

	test_floating_string
		-- ZSTRING_COMPARABLE_TEST_SET.test_floating_string
		note
			testing: "[
				covers/{EL_FLOATING_ZSTRING}.ends_with,
				covers/{EL_FLOATING_ZSTRING}.ends_with_character,
				covers/{EL_FLOATING_ZSTRING}.starts_with,
				covers/{EL_FLOATING_ZSTRING}.starts_with_character,
				covers/{EL_FLOATING_ZSTRING}.same_string,
				convers/{EL_MODULE_STRING}.shared_floating
			]"
		local
		 	str: ZSTRING
		do
			str := "%T one two three %T"
			if attached shared_floating (str) as floating then
				assert ("starts with one", floating.starts_with ("one"))
				assert ("ends with three", floating.ends_with ("three"))
				assert ("same string", floating.ends_with ("one two three"))
				assert ("starts with 'o'", floating.starts_with_character ('o'))
				assert ("ends with 'e'", floating.ends_with_character ('e'))
			end
		end

	test_same_caseless_characters
		-- ZSTRING_COMPARABLE_TEST_SET.test_same_caseless_characters
		note
			testing: "[
				covers/{EL_COMPARABLE_ZSTRING}.same_caseless_characters,
				covers/{EL_COMPARABLE_ZSTRING}.same_characters_8,
				covers/{EL_COMPARABLE_ZSTRING}.same_characters_32
			]"

		do
			assert_same_characters ("same_caseless_characters OK", True)
		end

	test_same_characters
		-- ZSTRING_COMPARABLE_TEST_SET.test_same_characters
		note
			testing: "[
				covers/{EL_COMPARABLE_ZSTRING}.same_characters,
				covers/{EL_COMPARABLE_ZSTRING}.same_characters_8,
				covers/{EL_COMPARABLE_ZSTRING}.same_characters_32
			]"
		do
			assert_same_characters ("same_characters OK", False)
		end

	test_starts_with
		-- ZSTRING_COMPARABLE_TEST_SET.test_starts_with
		note
			testing: "[
				covers/{EL_COMPARABLE_ZSTRING}.starts_with,
				covers/{EL_COMPARABLE_ZSTRING}.starts_with_character,
				covers/{EL_TRANSFORMABLE_ZSTRING}.remove_head,
				covers/{EL_SUBSTRING_32_ARRAY}.same_substring
			]"
		local
			test: STRING_TEST; assertion_OK: STRING
			index, start_index, end_index: INTEGER
		do
			across Text.lines as line loop
				create test.make (line.item)
				if attached test.word_intervals as list then
					from list.start until list.is_empty loop
						list.start
						start_index := list.item_lower; end_index := list.last_upper
						test.set_substrings (start_index, end_index)
						assert ("starts_with OK", test.starts_with)
						start_index := start_index + 1
						if test.s_32.valid_index (start_index) then
							test.set_substrings (start_index, end_index)
							assert ("starts_with OK", test.starts_with)
						end
						list.finish
						list.remove
					end
				end
			end
		end

feature {NONE} -- Implementation

	assert_same_characters (assertion_OK: STRING; is_case_insenstive: BOOLEAN)
		local
			start_index, end_index: INTEGER; test: STRING_TEST
		do
			across Text.lines as line loop
				if is_case_insenstive then
					create {CASELESS_STRING_TEST} test.make (line.item)
				else
					create test.make (line.item)
				end
				across test.all_word_interval_permutations as permutation loop
					if attached permutation.item as list then
						from list.start until list.after loop
							start_index := list.item_lower; end_index := list.item_upper
							test.set_substrings (start_index, end_index)
							assert (assertion_OK, test.same_characters (start_index))
							list.forth
						end
					end
				end
			end
		end

end