note
	description: "HTML text element list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 11:28:41 GMT (Sunday 1st September 2024)"
	revision: "31"

class
	HTML_TEXT_ELEMENT_LIST

inherit
	EL_ARRAYED_LIST [HTML_TEXT_ELEMENT]
		rename
			make as make_array
		redefine
			make_empty
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			Append as Append_mode,
			make as make_machine
		undefine
			is_equal, copy
		end

	EL_MODULE_TUPLE; EL_MODULE_XML

	MARKDOWN_ROUTINES
		undefine
			is_equal, copy
		end

	PUBLISHER_CONSTANTS

	EL_STRING_8_CONSTANTS; EL_ZSTRING_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			make_machine
			create lines.make_empty
			element_type := Empty_string_8
		end

	make (markdown_lines: EL_ZSTRING_LIST)
		do
			make_empty
			make_array (markdown_lines.count // 3)
			do_with_lines (agent parse_lines, markdown_lines)
			add_element
		end

feature {NONE} -- Line states Eiffel

	find_end_of_preformatted (line: ZSTRING)
		do
			if line.is_empty then
				lines.extend (Empty_string)
			elseif line [1] /= '%T' then
				add_element
				element_type := Type_paragraph
				state := agent parse_lines
				parse_lines (line)
			else
				lines.extend (line.substring_end (2))
			end
		end

	find_not_empty (line: ZSTRING)
		do
			if not line.is_empty then
				state := agent parse_lines
				parse_lines (line)
			end
		end

	find_end_of_list (line: ZSTRING)
		do
			if is_list_item (line) then
				if not lines.is_empty then
					lines.extend (new_list_item_tag (element_type, False))
				end
				lines.extend (new_list_item_tag (element_type, True) + line.substring_end (list_prefix_count (line) + 1))

			elseif line.is_empty then
				add_element
				element_type := Type_paragraph
				state := agent parse_lines

			elseif line [1] = '%T' then
				add_element
				element_type := Type_preformatted
				state := agent find_end_of_preformatted
				find_end_of_preformatted (line)
			else
				lines.extend (line)
			end
		end

	parse_lines (line: ZSTRING)
		do
			element_type := Type_paragraph
			if line.is_empty then
				add_element
				state := agent find_not_empty

			elseif is_list_item (line) then
				add_element
				element_type := list_type (line)
				state := agent find_end_of_list
				find_end_of_list (line)

			elseif line [1] = '%T' then
				add_element
				element_type := Type_preformatted
				state := agent find_end_of_preformatted
				find_end_of_preformatted (line)
			else
				lines.extend (line)
			end
		end

feature {NONE} -- Factory

	new_list_item_tag (type: STRING; is_open: BOOLEAN): ZSTRING
		-- returns one of: [li], [/li], [oli], [/oli]
		do
			if type = Type_ordered_list then
				Result := if is_open then Tag.oli else Tag.oli_close end

			elseif type = Type_unordered_list then
				Result := if is_open then Tag.li else Tag.li_close end
			else
				create Result.make_empty
			end
		ensure
			not_empty: Result.count > 0
		end

	new_html_element: HTML_TEXT_ELEMENT
		do
			create Result.make (Markdown.as_html (lines.joined_lines), element_type)
		end

	new_preformatted_html_element: HTML_TEXT_ELEMENT
		do
			create Result.make (XML.escaped (lines.joined_lines), Type_preformatted)
		end

feature {NONE} -- Implementation

	add_element
		do
			if not lines.is_empty then
				if element_type ~ Type_preformatted then
					lines.finish
					if lines.item.is_empty then
						lines.remove
					end
					lines.expand_tabs (3)
					lines := wrapped_lines
					extend (new_preformatted_html_element)
				else
					if element_type ~ Type_ordered_list or element_type ~ Type_unordered_list then
						lines.extend (new_list_item_tag (element_type, False))
					end
					extend (new_html_element)
				end
				lines.wipe_out
			end
		end

	wrapped_lines: EL_ZSTRING_LIST
		local
			excess_count: INTEGER; short_enough: BOOLEAN; spaces, line: ZSTRING
		do
			create Result.make (lines.count)
			if attached Word_list as words then
				across lines as list loop
					line := list.item
					Result.extend (line)
					if line.count > Maximum_code_width then
						excess_count := line.count - Maximum_code_width
						words.wipe_out
						from short_enough := False until short_enough loop
							words.put_front (line.substring_to_reversed (' '))
							line.remove_tail (words.first.count + 1)
							if line.count < Maximum_code_width then
								short_enough := True
							end
						end
						if attached words.joined_words as tail_line then
							create spaces.make_filled (' ', Class_link_list.adjusted_count (line) - excess_count)
							Result.extend (spaces + tail_line)
						end
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	element_type: STRING

	lines: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Tag: TUPLE [li, li_close, oli, oli_close: ZSTRING]
		local
			tag_list: ZSTRING
		once
			create Result
		-- Ordered list item with span to allow bold numbering using CSS
			tag_list := "<li>, </li>, <li><span>, </span></li>"
			tag_list.hide (Html_reserved)
			Tuple.fill (Result, tag_list)
		end

	Type_paragraph: STRING = "p"

	Type_preformatted: STRING = "pre"

	Markdown: MARKDOWN_RENDERER
		once
			create Result
		end

	Maximum_code_width: INTEGER
		once
			Result := 110
		end

	Word_list: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

end