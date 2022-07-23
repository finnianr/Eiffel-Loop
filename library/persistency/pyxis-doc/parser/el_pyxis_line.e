note
	description: "Pyxis line string with parse information attributes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-22 8:33:02 GMT (Friday 22nd July 2022)"
	revision: "5"

class
	EL_PYXIS_LINE

inherit
	STRING_8
		rename
			count as line_count,
			occurrences as line_occurrences
		export
			{NONE} all
			{ANY} as_string_8
		redefine
			is_double, share
		end

	EL_SHARED_STRING_8_CURSOR

	EL_PYXIS_PARSER_CONSTANTS

	EL_MODULE_BUFFER_8

create
	make_empty

feature -- Access

	element_name: detachable STRING
		-- name of element (tag) or `Void' if not a tag name
		do
			if is_element then
				Result := Buffer_8.copied_substring (Current, start_index, end_index - 1)
			end
		end

	xml_element: STRING
		local
			s_8: EL_STRING_8_ROUTINES
		do
			Result := Buffer_8.copied_substring (Current, start_index, end_index - 1)
			s_8.replace_character (Result, '.', ':')
		end

feature -- Measurement

	count: INTEGER

	end_index: INTEGER

	indent_count: INTEGER
		do
			Result := start_index - 1
		end

	index_of_equals: INTEGER
		do
			if count > 0 then
				Result := index_of ('=', start_index)
			end
		end

	occurrences (c: CHARACTER_8): INTEGER
		-- Number of times `c' appears in the content
		local
			i, i_final: INTEGER
			l_area: SPECIAL [CHARACTER_8]
		do
			from
				i := start_index - 1
				i_final := end_index - 1
				l_area := area
			until
				i > i_final
			loop
				if l_area.item (i) = c then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	start_index: INTEGER

feature -- Element change

	tab_left
		-- remove first tab
		require
			has_tabs: indent_count > 0
		do
			remove_head (1)
			start_index := start_index - 1
			end_index := end_index - 1
		end

	rename_element (tag_name: STRING)
		local
			delta: INTEGER
		do
			-- size difference
			delta := (count - 1) - tag_name.count
			replace_substring (tag_name, start_index, end_index - 1)
			if delta.to_boolean then
				end_index := end_index - delta
				count := count - delta
			end
		ensure
			renamed: attached element_name as name and then name ~ tag_name
		end

	replace (content: STRING)
		do
			keep_head (start_index - 1); append (content)
			end_index := line_count
			count := end_index - start_index + 1
		end

	set_element (a_name: STRING)
		do
			wipe_out
			append (a_name); append_character (':')
			start_index := 1
			end_index := line_count
			count := line_count
		ensure
			is_set: attached element_name as name and then name ~ a_name
		end

	set_start_index (a_index: INTEGER)
		do
			start_index := a_index
			count := end_index - a_index + 1
		end

	share (line: STRING_8)
		do
			Precursor (line)
			end_index := line.count - cursor_8 (line).trailing_white_count
			if end_index = 0 then
				set_start_index (1)
			else
				set_start_index (cursor_8 (line).leading_occurrences ('%T') + 1)
			end
		end

feature -- Basic operations

	append_comment_to (str: STRING)
		local
			i, i_final: INTEGER; found_start: BOOLEAN
		do
			i_final := end_index
			from i := start_index + 1 until found_start or else i > i_final loop
				if not item (i).is_space then
					found_start := True
				else
					i := i + 1
				end
			end
			if not str.is_empty then
				str.append_character ('%N')
			end
			str.append_substring (Current, i, end_index)
		end

	append_quoted_to_node (node: EL_DOCUMENT_NODE_STRING)
		do
			node.append_substring (Current, start_index + 1, end_index - 1)
		end

	append_to_node (node: EL_DOCUMENT_NODE_STRING)
		do
			node.append_substring (Current, start_index, end_index)
		end

	parse_attributes (parser: EL_PYXIS_ATTRIBUTE_PARSER)
		do
			parser.set_source_text_from_substring (Current, start_index, end_index)
			parser.parse
		end

feature -- Status query

	first_name_matches (a_name: STRING; equal_index: INTEGER): BOOLEAN
		local
			i: INTEGER; l_area: like area
		do
			l_area := area
			from i := equal_index - 1 until i = (start_index - 1) or else l_area [i - 1].is_alpha_numeric loop
				i := i - 1
			end
			if i >= start_index then
				Result := a_name.same_characters (Current, start_index, i, 1)
			end
		end

	has_quotes (quote: CHARACTER): BOOLEAN
		do
			if count >= 2 then
				Result := item (start_index) = quote and then item (end_index) = quote
			end
		end

	has_triple_quote: BOOLEAN
		do
			Result := count = 3 and then occurrences ('"') = 3
		end

	is_comment: BOOLEAN
		do
			Result := count > 0 and then area [start_index - 1] = '#'
		end

	is_double: BOOLEAN
		do
			 Result := Buffer_8.copied_substring (Current, start_index, end_index).is_double
		end

	is_element: BOOLEAN
		do
			Result := count > 1 and then area [end_index - 1] = ':'
		end

end