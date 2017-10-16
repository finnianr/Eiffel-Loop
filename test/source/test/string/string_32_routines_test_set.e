note
	description: "Summary description for {STRING_X_ROUTINES_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	STRING_32_ROUTINES_TEST_SET

inherit
	EQA_TEST_SET

	TEST_STRING_CONSTANTS
		undefine
			default_create
		end

	EL_MODULE_STRING_32
		undefine
			default_create
		end

feature -- Conversion tests

	test_delimited_list
		note
			testing: "covers/{EL_STRING_32_ROUTINES}.delimited_list",
						"covers/{EL_DELIMITED_SUBSTRING_INTERVALS}.make",
						"covers/{EL_OCCURRENCE_SUBSTRING_LIST}.make"
		local
			str, delimiter, str_2, l_substring: STRING_32
		do
			across Text_lines as line loop
				str := line.item
				from delimiter := " "  until delimiter.count > 2 loop
					create str_2.make_empty
					across String_32.delimited_list (str, delimiter) as substring loop
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
			across String_32.delimited_list (str, delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert ("delimited_list OK", str ~ Text_russian_and_english)
		end
end
