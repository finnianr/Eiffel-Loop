note
	description: "Summary description for {MARKUP_SUBSTITUTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-28 6:28:49 GMT (Wednesday 28th June 2017)"
	revision: "2"

class
	MARKUP_SUBSTITUTION

inherit
	EL_STRING_CONSTANTS

create
	make, make_hyperlink

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: ZSTRING)
		do
			delimiter_start := a_delimiter_start; delimiter_end := a_delimiter_end
			markup_open := a_markup_open; markup_close := a_markup_close
		end

	make_hyperlink (a_delimiter_start: ZSTRING)
		do
			make (a_delimiter_start, Right_square_bracket, Empty_string, Empty_string)
			is_hyperlink := True
		end

feature -- Status query

	is_hyperlink: BOOLEAN

feature -- Basic operations

	substitute_html (html: ZSTRING; new_expanded_link: FUNCTION [ZSTRING, ZSTRING, ZSTRING])
		local
			pos_open, pos_close, pos_space: INTEGER; done: BOOLEAN
			expanded_link, link_path, link_text: ZSTRING
		do
			from until done loop
				pos_open := html.substring_index (delimiter_start, pos_open + 1)
				if pos_open > 0 then
					pos_close := html.substring_index (delimiter_end, pos_open + delimiter_start.count)
					if pos_close > 0 then
						if is_hyperlink then
							pos_space := html.substring_index (Space_string, pos_open + delimiter_start.count)
							if pos_space > 0 and then pos_space < pos_close then
								link_path := html.substring (pos_open + 1, pos_space - 1)
								link_text := html.substring (pos_space + 1, pos_close - 1)
							else
								link_path := html.substring (pos_open + 1, pos_close - 1)
								link_text := link_path
							end
							expanded_link := new_expanded_link (link_path, link_text)
							html.replace_substring (expanded_link, pos_open, pos_close)
							pos_open := html.index_of ('>', pos_open)
						else
							html.replace_substring (markup_open, pos_open, pos_open + delimiter_start.count - 1)
							pos_close := pos_close + markup_open.count - delimiter_start.count
							html.replace_substring (markup_close, pos_close, pos_close + delimiter_end.count - 1)
						end
					end
				end
				done := pos_open = 0 or pos_close = 0
			end
		end

feature -- Access

	delimiter_end: ZSTRING

	delimiter_start: ZSTRING

	markup_close: ZSTRING

	markup_open: ZSTRING

feature {NONE} -- Constants

	Right_square_bracket: ZSTRING
		once
			Result := "]"
		end

end