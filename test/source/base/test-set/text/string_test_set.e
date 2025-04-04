﻿note
	description: "Test general string  routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 11:54:40 GMT (Saturday 5th April 2025)"
	revision: "40"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SIDE_ROUTINES

	EL_MODULE_CONVERT_STRING

	EL_STRING_GENERAL_ROUTINES_I

	EL_SHARED_ENCODINGS; EL_SHARED_TEST_TEXT

	EL_SHARED_STRING_32_CURSOR; EL_SHARED_STRING_8_CURSOR

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
				["adjusted_immutable_string",	agent test_adjusted_immutable_string],
				["bracketed",						agent test_bracketed],
				["delimited_list",				agent test_delimited_list],
				["encodeables",					agent test_encodeables],
				["immutable_string_manager",	agent test_immutable_string_manager],
				["match_wildcard",				agent test_match_wildcard],
				["name_table",						agent test_name_table],
				["name_value_pair",				agent test_name_value_pair],
				["readable_has_member",			agent test_readable_has_member],
				["remove_bookends",				agent test_remove_bookends],
				["selected_name",					agent test_selected_name],
				["variable_pattern",				agent test_variable_pattern],
				["word_count",						agent test_word_count]
			>>)
		end

feature -- Tests

	test_adjusted_immutable_string
		-- STRING_TEST_SET.test_adjusted_immutable_string
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_MANAGER}.set_adjusted_item
			]"
		local
			str, adjusted: STRING_8; manager_8: EL_IMMUTABLE_8_MANAGER
		do
			create manager_8
			across << "  abc  ", "abc", " abc", "abc ", "" >> as list loop
				str := list.item
				adjusted := str.twin
				adjusted.adjust
				manager_8.set_adjusted_item (str.area, 0, str.count, {EL_SIDE}.Both)
				assert_same_string ("adjusted immutable", manager_8.item, adjusted)
			end
		end

	test_bracketed
		-- STRING_TEST_SET.test_bracketed
		note
			testing: "[
				covers/{EL_READABLE_STRING_X_ROUTINES}.bracketed,
				covers/{EL_CHARACTER_ROUTINES}.right_bracket,
				covers/{EL_STRING_ITERATION_CURSOR}.matching_bracket_index
			]"
		local
			s: EL_STRING_8_ROUTINES; content: STRING
			name, name_2: IMMUTABLE_STRING_8; type_array: ARRAY [TYPE [ANY]]
		do
			type_array := << {ARRAYED_LIST [INTEGER]}, {ARRAYED_LIST [CELL [INTEGER]]} >>
			across type_array as array loop
				across << False, True >> as is_last loop
					name := array.item.name
					if is_last.item then
						content := s.bracketed_last (name, '[')
						name_2 := ({INTEGER}).name
					else
						content := s.bracketed (name, '[')
						name_2 := if array.is_first then ({INTEGER}).name else ({CELL [INTEGER]}).name end
					end
					assert_same_string (Void, content, name_2)
				end
			end
		end

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

	test_immutable_string_manager
		-- STRING_TEST_SET.test_immutable_string_manager
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_MANAGER}.set_item,
				covers/{EL_IMMUTABLE_STRING_MANAGER}.new_substring
			]"
		local
			manager_32: EL_IMMUTABLE_32_MANAGER; manager_8: EL_IMMUTABLE_8_MANAGER
			word_8: STRING_8; word_32: STRING_32; word_index: INTEGER
		do
			create manager_32; create manager_8
			across Text.lines_32 as line loop
				if line.item.is_valid_as_string_8 and then attached line.item.to_string_8 as line_item_8 then
					if attached line_item_8.split (' ') as words then
						word_8 := words [2]
						word_index := line.item.substring_index (word_8, 1)
						if attached cursor_8 (line_item_8) as cursor then
							manager_8.set_item (cursor.area, word_index - 1, word_8.count)
							assert_same_string (Void, manager_8.item, word_8)
							word_8 := words [1]
	--						same as first word
							assert_same_string (Void, manager_8.new_substring (cursor.area, 0, word_8.count), word_8)
						end
					end
				elseif attached line.item.split (' ') as words then
					word_32 := words [2]
					word_index := line.item.substring_index (word_32, 1)
					if attached cursor_32 (line.item) as cursor then
						manager_32.set_item (cursor.area, word_index - 1, word_32.count)
						assert_same_string (Void, manager_32.item, word_32)
						word_32 := words [1]
--						same as first word
						assert_same_string (Void, manager_32.new_substring (cursor.area, 0, word_32.count), word_32)
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
			word: EL_EXTENDED_READABLE_STRING [COMPARABLE]; empty_pattern, pattern: READABLE_STRING_GENERAL
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
			str, abc, def: IMMUTABLE_STRING_8; s: EL_STRING_8_ROUTINES
		do
			str := "abcdef"; abc := str.shared_substring (1, 3); def := str.shared_substring (4, 6)
			assert ("in set", s.has_member (str, Current))
			assert ("in set", s.has_member (abc, Current))
			assert ("not in set", not s.has_member (def, Current))
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
		do
			assert_same_string (Void, side_name ({EL_SIDE}.None), "None")
			assert_same_string (Void, side_name ({EL_SIDE}.Right), "Right")
		end

	test_variable_pattern
		-- STRING_TEST_SET.test_variable_pattern
		note
			testing: "[
				covers/{EL_EXTENDED_STRING_GENERAL}.is_variable_reference,
				covers/{EL_READABLE_STRING_X_ROUTINES}.is_variable_reference,
				covers/{EL_COMPARABLE_ZSTRING}.matches_wildcard
			]"
		local
			z: EL_ZSTRING_ROUTINES; s: EL_STRING_8_ROUTINES
			str: ZSTRING
		do
			across << "$index", "${index}", "index" >> as list loop
				if attached list.item as str_8 then
					assert ("matches", str_8 [1] = '$' implies s.is_variable_reference (str_8))
					assert ("matches", str_8 [1] = '$' implies super_8 (str_8).is_variable_reference)
					str := str_8
					assert ("matches", str [1] = '$' implies z.is_variable_reference (str))
				end
			end
		end

	test_word_count
		-- STRING_TEST_SET.test_word_count
		note
			testing: "[
				covers/{EL_READABLE_STRING_X_ROUTINES}.word_count
			]"
		local
			z: EL_ZSTRING_ROUTINES; s: EL_STRING_8_ROUTINES; word_count: INTEGER
			string: STRING; string_type_list: ARRAY [STRING_GENERAL]
		do
			string := "one; ${index} two%T patrick's"
			string_type_list := << string, ZSTRING (string) >>
			across string_type_list as list loop
				if attached list.item as l_text then
					across 1 |..| 2 as n loop
						if l_text.is_string_8 and then attached {STRING} l_text as str_8 then
							word_count := s.word_count (str_8, True)

						elseif attached {ZSTRING} l_text as z_str then
							word_count := z.word_count (z_str, True)
						end
						assert ("3 words", word_count = 3)
						l_text.prepend ("%N "); l_text.append ("%N ")
					end
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