﻿note
	description: "Test general string  routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 14:14:51 GMT (Thursday 17th April 2025)"
	revision: "47"

class
	STRING_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

	EL_SIDE_ROUTINES

	EL_MODULE_CONVERT_STRING

	EL_STRING_GENERAL_ROUTINES_I

	EL_SHARED_ENCODINGS

	SHARED_COLOR_ENUM

	EL_SET [CHARACTER_8]
		rename
			has as has_a_to_c
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["delimited_list",				agent test_delimited_list],
				["encodeables",					agent test_encodeables],
				["match_wildcard",				agent test_match_wildcard],
				["name_table",						agent test_name_table],
				["name_value_pair",				agent test_name_value_pair],
				["readable_has_member",			agent test_readable_has_member],
				["remove_bookends",				agent test_remove_bookends],
				["selected_name",					agent test_selected_name]
			>>)
		end

feature -- Tests

	test_delimited_list
		note
			testing: "[
				covers/{EL_STRING_32_ROUTINES}.delimited_list,
				covers/{EL_SPLIT_STRING_LIST}.make,
				covers/{EL_OCCURRENCE_INTERVALS}.make
			]"
		local
			str, delimiter, str_2, l_substring: STRING_32
			s: EL_STRING_32_ROUTINES
		do
			across Text.lines_32 as line loop
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
			str := Text.Mixed_text; delimiter := "Latin"
			across s.delimited_list (str, delimiter) as substring loop
				l_substring := substring.item
				if substring.cursor_index > 1 then
					str_2.append (delimiter)
				end
				str_2.append (l_substring)
			end
			assert ("delimited_list OK", str ~ Text.Mixed_text)
		ensure
			line_2_starts_with_W: Text.lines_32.i_th (2).item (1) = 'W'
		end

	test_encodeables
		-- STRING_TEST_SET.test_encodeables
		note
			testing: "[
				covers/{EL_OUTPUT_MEDIUM}.put_other,
				covers/{EL_ENCODING_BASE}.set_from_name
			]"
		local
			buffer: EL_STRING_8_IO_MEDIUM; encoding: ENCODING
			is_ansi: BOOLEAN; line: EL_STRING_8
		do
			create buffer.make (50)
			buffer.set_encoding_other (Encodings.Utf_8)
			assert ("is utf-8", buffer.encoded_as_utf (8))

			create encoding.make ("850")
			buffer.set_encoding_from_name ("cp850")
			assert ("same encoding", buffer.encoding_other ~ encoding)

			buffer.set_encoding_other (Console.Encoding)
			is_ansi := Console.code_page.has_substring ("ANSI")

			across Text.lines_8 as list loop
				create line.make_from_string (list.item)
				if attached Encodings.Unicode as unicode then
					if is_ansi implies line.is_ascii then
						Buffer.wipe_out
						Buffer.put_string_8 (line)
						unicode.convert_to (Console.Encoding, line)
						assert ("conversion successful", unicode.last_conversion_successful)
						assert_same_string (Void, Buffer.text, unicode.last_converted_string_8)
					end
				end
			end
		end

	test_match_wildcard
		-- STRING_TEST_SET.test_match_wildcard
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING_I}.matches_wildcard,
				covers/{EL_EXTENDED_READABLE_STRING_I}.new_shared_substring,
				covers/{EL_IMMUTABLE_STRING_MANAGER}.shared_substring,
				covers/{EL_STRING_CONVERSION_TABLE}.split_list,
				covers/{EL_COMPARABLE_ZSTRING}.matches_wildcard
			]"
		local
			word: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]; empty_pattern, pattern: READABLE_STRING_GENERAL
		do
			across new_string_type_list ("encylopedia, *dia, enc*, *lop*, *") as csv_list loop
				if attached Convert_string.split_list (csv_list.item, ',', {EL_SIDE}.Left) as split_list then
					across split_list as list loop
						if list.cursor_index = 1 then
							word := super_readable_general (list.item)
							empty_pattern := list.item.substring (1, 0)
							assert ("empty not matched", not word.matches_wildcard (empty_pattern))
						else
							pattern := list.item
							assert ("matches wildcard", word.matches_wildcard (pattern))
						end
					end
				end
			end
		end

	test_name_table
		-- STRING_TEST_SET.test_name_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_NAME_TABLE}.make
			]"
		local
			natural_codes: ARRAYED_LIST [NATURAL_8]; symbol_table: EL_IMMUTABLE_NAME_TABLE [NATURAL_8]
		do
			if attached Text.symbol_32_list as symbol_list then
				symbol_list.finish; symbol_list.remove -- remove "%T"

				create natural_codes.make (symbol_list.count)
				from until natural_codes.full loop
					natural_codes.extend ((natural_codes.count + 1).to_natural_8)
				end
				create symbol_table.make_general (natural_codes.to_array, symbol_list.joined_with_string (", "))
				across natural_codes as code loop
					assert ("same name", symbol_table.item_32 (code.item) ~ symbol_list [code.cursor_index])
				end
			end
		end

	test_name_value_pair
		-- STRING_TEST_SET.test_name_value_pair
		note
			testing: "[
				covers/{EL_NAME_VALUE_PAIR}.make_quoted,
				covers/{EL_NAME_VALUE_PAIR}.set_from_string,
				covers/{EL_NAME_VALUE_PAIR}.set_from_substring
			]"
		local
			pair: EL_NAME_VALUE_PAIR [STRING] name, value, name_value: STRING
		do
			create pair.make_empty
			across << "a=b", "a=", "=b" >> as list loop
				across << {EL_SIDE}.None, {EL_SIDE}.Left, {EL_SIDE}.Right, {EL_SIDE}.Both >> as side loop
					if attached list.item.split ('=') as part_list then
						across part_list as part loop
							if attached part.item as s then
								inspect side.item
									when {EL_SIDE}.Left then
										s.prepend_character (' ')
									when {EL_SIDE}.Right then
										s.append_character (' ')
									when {EL_SIDE}.Both then
										s.prepend_character (' ')
										s.append_character (' ')
								else
								end
							end
						end
						name := part_list.first; value := part_list.last
						name_value := name + "=" + value
						pair.set_from_string (name_value, '=')
						name.adjust; value.adjust
						assert ("same name", name ~ pair.name)
						assert ("same value", value ~ pair.value)
					end
				end
			end
			create pair.make_quoted ("a = %"3%"", '=')
			assert ("is 3", pair.value ~ "3")
		end

	test_readable_has_member
		-- STRING_TEST_SET.test_readable_has_member
		note
			testing: "[
				covers/{EL_EXTENDED_READABLE_STRING}.has_member,
				covers/{EL_READABLE_STRING_X_ROUTINES}.has_member
			]"
		local
			str, abc, def: IMMUTABLE_STRING_8
		do
			str := "abcdef"; abc := str.shared_substring (1, 3); def := str.shared_substring (4, 6)
			assert ("in set", super_readable_8 (str).has_member (Current))
			assert ("in set", super_readable_8 (abc).has_member (Current))
			assert ("not in set", not super_readable_8 (def).has_member (Current))
		end

	test_remove_bookends
		-- STRING_TEST_SET.test_remove_bookends
		local
			str: STRING
		do
			str := "{VAR}"
			super_8 (str).remove_bookends ('{', '}')
			assert_same_string (Void, str, "VAR")
		end

	test_selected_name
		-- STRING_TEST_SET.test_selected_name
		note
			testing: "[
				covers/{EL_EXTENDED_STRING_GENERAL}.selected_substring,
				covers/{EL_SIDE_ROUTINES}.side_name
			]"
		local
			none, right: READABLE_STRING_GENERAL; range: INTEGER_INTERVAL
		do
			range := 0 |..| Both_sides
			across new_string_type_list (Side_name_list) as list loop
				if attached list.item as name_list then
					none := super_readable_general (name_list).selected_substring ({EL_SIDE}.None, range)
					assert_same_string (Void, none, "None")

					right := super_readable_general (name_list).selected_substring ({EL_SIDE}.Right, range)
					assert_same_string (Void, right, "Right")
				end
			end
		end

feature {NONE} -- Implementation

	has_a_to_c (c: CHARACTER): BOOLEAN
		do
			inspect c
				when 'a' .. 'c' then
					Result := True
			else
			end
		end
end