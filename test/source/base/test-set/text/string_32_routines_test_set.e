note
	description: "String 32 routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-16 11:25:49 GMT (Thursday 16th February 2023)"
	revision: "20"

class
	STRING_32_ROUTINES_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

	EL_SHARED_STRING_32_CURSOR

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("delimited_list", agent test_delimited_list)
			eval.call ("immutable_32_manager", agent test_immutable_32_manager)
		end

feature -- Tests

	test_delimited_list
		note
			testing: "covers/{EL_STRING_32_ROUTINES}.delimited_list",
						"covers/{EL_SPLIT_STRING_LIST}.make",
						"covers/{EL_OCCURRENCE_INTERVALS}.make"
		local
			str, delimiter, str_2, l_substring: STRING_32
			s: EL_STRING_32_ROUTINES
		do
			across Text.lines as line loop
				str := line.item
				from delimiter := " "  until delimiter.count > 2 loop
					create str_2.make_empty
					across s.delimited_list (str, delimiter) as substring loop
						l_substring := substring.item
						if substring.cursor_index > 1 then
							str_2.append (delimiter)
						end
						str_2.append (l_substring)
					end
					assert ("substring_split OK", str ~ str_2)
					delimiter.prepend_character ('и')
				end
			end
			str := Text.Russian_and_english; delimiter := "Latin"
			across s.delimited_list (str, delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert ("delimited_list OK", str ~ Text.Russian_and_english)
		ensure
			line_2_starts_with_W: Text.lines.i_th (2).item (1) = 'W'
		end

	test_immutable_32_manager
		-- STRING_32_ROUTINES_TEST_SET.test_immutable_32_manager
		local
			manager: EL_IMMUTABLE_32_MANAGER
			line_1, word_1, word_2: STRING_32
		do
			line_1 := Text.lines.first
			if attached line_1.split (' ') as words then
				word_1 := words [1]
				word_2 := words [2]
			end
			create manager
			if attached cursor_32 (line_1) as cursor then
				manager.set_item (cursor.area, 2, 5)
				assert_same_string (Void, manager.item, word_2)
				assert_same_string (Void, manager.new_substring (cursor.area, 0, 1), word_1)
			end
		end

end