note
	description: "Expand class notes with source hyperlink: [$source MY_CLASS [ANY]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 7:48:03 GMT (Thursday 17th August 2023)"
	revision: "8"

class
	SOURCE_LINK_SUBSTITUTION

inherit
	HYPERLINK_SUBSTITUTION
		rename
			make as make_hyperlink,
			expand_hyperlink_markup as expand_as_source_link
		redefine
			substitute_html, expand_as_source_link, new_expanded_link, A_href_template
		end

	PUBLISHER_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	SHARED_CLASS_PATH_TABLE; SHARED_ISE_CLASS_TABLE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_hyperlink (Square_bracket.left)
			create delimiter_start.make_filled ('[', 1)
			delimiter_start.append (Source_variable)
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		do
			Editor.set_target (html_string)
			Editor.for_each_balanced ('[', ']', Source_variable, agent expand_as_source_link)
		end

feature {NONE} -- Implementation

	expand_as_source_link (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_text: ZSTRING
		do
			link_text := substring.substring (start_index, end_index)
			link_text.adjust
			substring.share (new_expanded_link (Source_variable, link_text))
		end

	new_expanded_link (path, text: ZSTRING): ZSTRING
		local
			l_path, link_text: ZSTRING
		do
			if text.has (' ') then
				create link_text.make (text.count + text.occurrences (' ') * None_breaking_space.count)
				link_text.append_replaced (text, space * 1, None_breaking_space)
			else
				link_text := text
			end
			if Class_path_table.has_class (text) then
				l_path := Class_path_table.found_item.universal_relative_path (relative_page_dir)
			elseif ISE_class_table.has_class (text) then
				l_path := ISE_class_table.found_item
			else
				l_path := path
			end
			Result := A_href_template #$ [l_path, link_text]
		end

feature {NONE} -- Constants

	A_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#" id="source" target="_blank">#</a>
			]"
		end

end