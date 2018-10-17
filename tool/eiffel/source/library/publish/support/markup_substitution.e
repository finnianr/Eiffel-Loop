note
	description: "Markup substitution"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:47:17 GMT (Wednesday 17th October 2018)"
	revision: "5"

class
	MARKUP_SUBSTITUTION

inherit
	EL_ZSTRING_CONSTANTS

create
	make, make_hyperlink

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: ZSTRING)
		do
			delimiter_start := a_delimiter_start; delimiter_end := a_delimiter_end
			markup_open := a_markup_open; markup_close := a_markup_close
			new_expanded_link := agent empty_link
		end

	make_hyperlink (a_delimiter_start: ZSTRING)
		do
			make (a_delimiter_start, Right_square_bracket, Empty_string, Empty_string)
			is_hyperlink := True
		end

feature -- Status query

	is_hyperlink: BOOLEAN

feature -- Basic operations

	substitute_html (html: ZSTRING; new_link_agent: like new_expanded_link)
		do
			if is_hyperlink then
				new_expanded_link := new_link_agent
				html.edit (delimiter_start, delimiter_end, agent expand_hyperlink_markup)
			else
				html.edit (delimiter_start, delimiter_end, agent expand_markup)
			end
		end

feature -- Access

	delimiter_end: ZSTRING

	delimiter_start: ZSTRING

	markup_close: ZSTRING

	markup_open: ZSTRING

feature {NONE} -- Implementation

	expand_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.replace_substring (markup_close, end_index + 1, substring.count)
			substring.replace_substring (markup_open, 1, start_index - 1)
		end

	expand_hyperlink_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			expanded_link, link_path, link_text: ZSTRING
			space_index: INTEGER
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

	empty_link (path, text: ZSTRING): ZSTRING
		do
			create Result.make_empty
		end

	new_expanded_link: FUNCTION [ZSTRING, ZSTRING, ZSTRING]

feature {NONE} -- Constants

	Right_square_bracket: ZSTRING
		once
			Result := "]"
		end

end
