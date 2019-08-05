note
	description: "Html text element list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:54:47 GMT (Monday 5th August 2019)"
	revision: "9"

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
			make as make_machine
		undefine
			is_equal, copy
		end

	MARKDOWN_ROUTINES
		undefine
			is_equal, copy
		end

	EL_STRING_8_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_MODULE_XML

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

	new_filler (n: INTEGER): ZSTRING
		do
			create Result.make_filled (' ', n)
		end

	new_list_item_tag (type: STRING; open: BOOLEAN): STRING
		-- returns one of: [li], [oli], [/li], [/oli]
		do
			create Result.make (6)
			Result.append (once "[li]")
			if type = Type_ordered_list then
				Result.insert_character ('o', 2)
			end
			if not open then
				Result.insert_character ('/', 2)
			end
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
		local
			pos_space: INTEGER; line: ZSTRING
		do
			if not lines.is_empty then
				if element_type ~ Type_preformatted then
					lines.finish
					if lines.item.is_empty then
						lines.remove
					end
					lines.expand_tabs (3)
					from lines.start until lines.after loop
						line := lines.item
						if line.count > Maximum_code_width then
							from pos_space := line.count + 1 until pos_space < Maximum_code_width loop
								pos_space := line.last_index_of (' ', pos_space - 1)
							end
							line := line.substring_end (pos_space)
							lines.item.remove_tail (line.count)
							lines.put_right (new_filler (Maximum_code_width - line.count) + line)
							lines.forth
						end
						lines.forth
					end
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

feature {NONE} -- Internal attributes

	element_type: STRING

	lines: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Type_paragraph: STRING = "p"

	Type_preformatted: STRING = "pre"

	Markdown: MARKDOWN_RENDERER
		once
			create Result
		end

	Maximum_code_width: INTEGER
		once
			Result := 83
		end

end
