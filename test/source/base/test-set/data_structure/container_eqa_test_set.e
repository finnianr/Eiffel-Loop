note
	description: "Routines for testing container classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 8:16:47 GMT (Tuesday 22nd April 2025)"
	revision: "2"

deferred class
	CONTAINER_EQA_TEST_SET

inherit
	BASE_EQA_TEST_SET

	EL_ENCODING_TYPE

	EL_CONTAINER_CONVERSION [CHARACTER]
		undefine
			default_create
		end

	SHARED_COLOR_ENUM; EL_SHARED_ZCODEC_FACTORY; SHARED_DEV_ENVIRON

feature {NONE} -- Widget Implementation

	any_widget: EL_ANY_QUERY_CONDITION [WIDGET]
		do
			create Result
		end

	color_is (a_color: NATURAL_8): EL_PREDICATE_QUERY_CONDITION [WIDGET]
		do
			Result := agent {WIDGET}.is_color (a_color)
		end

	widget_colors: EL_ARRAYED_LIST [NATURAL_8]
		do
			create Result.make (10)
			across Widget_list as list loop
				Result.extend (list.item.color)
			end
		end

	widget_has_width (widget: WIDGET; a_width: INTEGER): BOOLEAN
		do
			Result := widget.width = a_width
		end

feature {NONE} -- Implementation

	add_path_step_count (line: ZSTRING; counter: INTEGER_REF)
		do
			counter.set_item (counter.item + path_step_count (line))
		end

	ascii_code (c: CHARACTER): NATURAL
		do
			Result := c.natural_32_code
		end

	character_fill (container: COLLECTION [CHARACTER])
		do
			across Character_string as c loop
				container.put (c.item)
			end
		end

	character_is_digit: EL_PREDICATE_QUERY_CONDITION [CHARACTER]
		do
			Result := agent is_character_digit
		end

	is_character_digit (c: CHARACTER): BOOLEAN
		do
			Result := c.is_digit
		end

	line_has_word (line, word: ZSTRING): BOOLEAN
		do
			Result := line.has_substring (word)
		end

	new_character_arrayed_list (variation: INTEGER): ARRAYED_LIST [CHARACTER]
		do
			if variation = 1 then
				create Result.make (Character_string.count)
			else
				create {EL_ARRAYED_LIST [CHARACTER]} Result.make (Character_string.count)
			end
			character_fill (Result)
		end

	new_character_containers: ARRAY [CONTAINER [CHARACTER]]
		do
			Result := <<
				new_character_arrayed_list (1), new_character_arrayed_list (2),
				new_character_table (1), new_character_table (1),
				new_character_tree,
				new_character_linked_list,
				new_character_set
			>>
		end

	new_character_linked_list: LINKED_LIST [CHARACTER]
		do
			create Result.make
			character_fill (Result)
		end

	new_character_set: EL_HASH_SET [CHARACTER]
		do
			create Result.make_equal (Character_string.count)
			character_fill (Result)
		end

	new_character_table (variation: INTEGER): HASH_TABLE [CHARACTER, NATURAL]
		do
			if variation.item = 1 then
				create Result.make (Character_string.count)
			else
				create {EL_HASH_TABLE [CHARACTER, NATURAL]} Result.make (Character_string.count)
			end
			across Character_string as c loop
				Result.put (c.item, c.item.natural_32_code)
			end
		end

	new_character_tree: BINARY_SEARCH_TREE [CHARACTER]
		do
			create Result.make (Character_string [1])
			across Character_string as str loop
				if str.cursor_index > 1 then
					Result.put (str.item)
				end
			end
		end

	path_step_count (line: ZSTRING): INTEGER
		local
			path: FILE_PATH
		do
			path := line
			Result := path.step_count
		end

	to_character_string (c: CHARACTER): STRING
		do
			Result := c.out
		end

	to_integer (c: CHARACTER): INTEGER
		local
			c8: EL_CHARACTER_8_ROUTINES
		do
			Result := c8.digit_to_integer (c)
		end

feature {NONE} -- Constants

	Character_string: STRING = "a1-b2-c3"

	Widget_list: EL_ARRAYED_LIST [WIDGET]
		once
			create Result.make_from_array (<<
				[Color.red, 200], [Color.blue, 300], [Color.green, 100], [Color.blue, 500], [Color.red, 1200]
			>>)
		end

	Widget_table: EL_HASH_TABLE [WIDGET, STRING]
		do
			create Result.make_assignments (<<
				["red",	 create {WIDGET}.make_2 (Color.red, 1200)],
				["blue",	 create {WIDGET}.make_2 (Color.blue, 300)],
				["green", create {WIDGET}.make_2 (Color.blue, 100)]
			>>)
		end

end