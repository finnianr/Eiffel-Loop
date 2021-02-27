note
	description: "Markup substitution"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 19:20:10 GMT (Saturday 27th February 2021)"
	revision: "8"

class
	MARKUP_SUBSTITUTION

inherit
	ANY

	EL_ZSTRING_CONSTANTS

create
	make, make_hyperlink, make_source_hyperlink

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: ZSTRING)
		do
			delimiter_start := a_delimiter_start; delimiter_end := a_delimiter_end
			markup_open := a_markup_open; markup_close := a_markup_close
			new_expanded_link := agent empty_link
			create class_parameter_list.make_empty
		end

	make_hyperlink (a_delimiter_start: ZSTRING)
		do
			make (a_delimiter_start, Right_square_bracket, Empty_string, Empty_string)
			is_hyperlink := True
		end

	make_source_hyperlink
		do
			make ("[$source", Right_square_bracket, Empty_string, Empty_string)
			is_hyperlink := True; is_source_link := True
		end

feature -- Status query

	is_hyperlink: BOOLEAN

	is_source_link: BOOLEAN

feature -- Basic operations

	substitute_html (html: ZSTRING; new_link_agent: like new_expanded_link)
		local
			incorrect, corrected: ZSTRING
		do
			if is_hyperlink then
				new_expanded_link := new_link_agent
				html.edit (delimiter_start, delimiter_end, agent expand_hyperlink_markup)
			else
				html.edit (delimiter_start, delimiter_end, agent expand_markup)
			end
			-- Correct class parameters. For example: [EL_STORABLE</a>] -> [EL_STORABLE]</a>
			if is_source_link and class_parameter_list.count > 0 then
				incorrect := String_pool.reuseable_item; corrected := String_pool.reuseable_item
				across class_parameter_list as list loop
					incorrect.wipe_out; corrected.wipe_out
					incorrect.append (list.item); incorrect.append (Anchor_close); incorrect.append_character (']')
					corrected.append (list.item); corrected.append_character (']'); corrected.append (Anchor_close)
					html.replace_substring_all (incorrect, corrected)
				end
				String_pool.recycle (incorrect); String_pool.recycle (corrected)
			end
		end

feature -- Access

	delimiter_end: ZSTRING

	delimiter_start: ZSTRING

	markup_close: ZSTRING

	markup_open: ZSTRING

feature {NONE} -- Implementation

	empty_link (path, text: ZSTRING; a_is_source_link: BOOLEAN): ZSTRING
		do
			create Result.make_empty
		end

	expand_hyperlink_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		local
			link_path, link_text: ZSTRING
			space_index, left_bracket_index: INTEGER
		do
			substring.to_canonically_spaced
			space_index := substring.index_of (' ', 1)
			if space_index > 0 then
				link_path := substring.substring (2, space_index - 1)
				link_text := substring.substring (space_index + 1, substring.count - 1)
				if is_source_link then
					left_bracket_index := link_text.index_of ('[', 1)
					if left_bracket_index > 0 then
						class_parameter_list.extend (link_text.substring_end (left_bracket_index))
					end
				end
			else
				link_path := substring.substring (2, substring.count - 1)
				link_text := link_path
			end
			substring.share (new_expanded_link (link_path, link_text, is_source_link))
		end

	expand_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.replace_substring (markup_close, end_index + 1, substring.count)
			substring.replace_substring (markup_open, 1, start_index - 1)
		end

feature {NONE} -- Internal attributes

	new_expanded_link: FUNCTION [ZSTRING, ZSTRING, BOOLEAN, ZSTRING]

	class_parameter_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	Right_square_bracket: ZSTRING
		once
			Result := "]"
		end

	Anchor_close: ZSTRING
		once
			Result := "</a>"
		end

end