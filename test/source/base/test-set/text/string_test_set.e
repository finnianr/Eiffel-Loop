note
	description: "Test general string  routines test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-29 12:48:51 GMT (Wednesday 29th May 2024)"
	revision: "26"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

	EL_SHARED_STRING_32_CURSOR; EL_SHARED_STRING_8_CURSOR

	PRIMARY_COLOR_CONSTANTS

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
				["immutable_string_manager",	agent test_immutable_string_manager],
				["name_table",						agent test_name_table]
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
				covers/{EL_STRING_X_ROUTINES}.bracketed,
				covers/{EL_CHARACTER_ROUTINES}.right_bracket,
				covers/{EL_STRING_ITERATION_CURSOR}.matching_bracket_index
			]"
		local
			s: EL_STRING_8_ROUTINES; content: STRING
		do
			content := s.bracketed (({ARRAYED_LIST [INTEGER]}).name, '[')
			assert_same_string (Void, content, ({INTEGER}).name)

			content := s.bracketed (({ARRAYED_LIST [CELL [INTEGER]]}).name, '[')
			assert_same_string (Void, content, ({CELL [INTEGER]}).name)
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
			across Text.lines as line loop
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

	test_name_table
		-- STRING_TEST_SET.test_name_table
		note
			testing: "[
				covers/{EL_IMMUTABLE_NAME_TABLE}.make,
				covers/{EL_READABLE_STRING_X_ROUTINES}.selected
			]"
		local
			s: EL_STRING_8_ROUTINES
		do
			across Valid_colors as color loop
				assert_same_string (
					"same color name", s.selected (color.item, Valid_colors, Color_names), Color_name_table [color.item]
				)
			end
		end


end