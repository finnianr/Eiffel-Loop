note
	description: "Expand hyperlink"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 10:07:02 GMT (Wednesday 3rd April 2024)"
	revision: "9"

class
	HYPERLINK_SUBSTITUTION

inherit
	MARKUP_SUBSTITUTION
		rename
			make as make_substitution
		redefine
			substitute_html
		end

create
	make

feature {NONE} -- Initialization

	make (a_delimiter_start: READABLE_STRING_GENERAL)
		do
			make_substitution (a_delimiter_start, char (']'), Empty_string, Empty_string)
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		do
			html_string.edit (delimiter_start, delimiter_end, agent expand_hyperlink_markup)
		end

feature -- Status query

	has_link (html_string: ZSTRING): BOOLEAN
		do
			Result := html_string.has_substring (delimiter_start)
		end

feature {NONE} -- Implementation

	expand_hyperlink_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_path, link_text: ZSTRING; space_index: INTEGER
		do
			substring.to_canonically_spaced
			space_index := substring.index_of (' ', 1)
			if space_index > 0 then
				link_path := substring.substring (2, space_index - 1)
				link_text := substring.substring (space_index + 1, substring.count - 1)
			else
				link_path := substring.substring (2, substring.count - 1)
				link_text := link_path
			end
			substring.share (new_expanded_link (link_path, link_text))
		end

	new_expanded_link (path, text: ZSTRING): ZSTRING
		do
		-- `path' might contain a '&' character
			Result := Html_link_template #$ [new_faux_markup (path), Empty_string, text]
		end

end