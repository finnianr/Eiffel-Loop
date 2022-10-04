note
	description: "String 32 routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:51:10 GMT (Tuesday 4th October 2022)"
	revision: "13"

class
	STRING_32_ROUTINES_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_TEST_STRINGS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("delimited_list", agent test_delimited_list)
		end

feature -- Conversion tests

	test_delimited_list
		note
			testing: "covers/{EL_STRING_32_ROUTINES}.delimited_list",
						"covers/{EL_SPLIT_STRING_LIST}.make",
						"covers/{EL_OCCURRENCE_INTERVALS}.make"
		local
			str, delimiter, str_2, l_substring: STRING_32
			s: EL_STRING_32_ROUTINES
		do
			across Text_lines as line loop
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
			str := Text_russian_and_english; delimiter := "Latin"
			across s.delimited_list (str, delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert ("delimited_list OK", str ~ Text_russian_and_english)
		ensure
			line_2_starts_with_W: Text_lines.i_th (2).item (1) = 'W'
		end
end