note
	description: "String 32 routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 8:42:12 GMT (Saturday 29th October 2022)"
	revision: "15"

class
	STRING_32_ROUTINES_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_CONVERT_STRING; EL_MODULE_LIO

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_TEST_TEXT

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("convert_string_type_descriptions", agent test_convert_string_type_descriptions)
			eval.call ("delimited_list", agent test_delimited_list)
		end

feature -- Conversion tests

	test_convert_string_type_descriptions
		note
			testing: "covers/{EL_READABLE_STRING_GENERAL_TO_TYPE}.new_type_description"
		do
			if attached crc_generator as crc then
				output_type_descriptions (crc)
				lio.put_natural_field ("Checksum", crc.checksum)
				lio.put_new_line
				if crc.checksum = 176473444 then
					assert ("Expected descriptions", True)
				else
					output_type_descriptions (Void)
				end
			end
		end

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

feature {NONE} -- Implementation

	output_type_descriptions (crc_check: detachable EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across Convert_string.type_list as list loop
				if attached Convert_string.type_descripton (list.item) as description then
					if attached crc_check as crc then
						crc.add_string_8 (description)
					else
						lio.put_line (description)
					end
				end
			end
		end
end