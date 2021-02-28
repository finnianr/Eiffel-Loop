note
	description: "Markup substitution"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-28 17:36:05 GMT (Sunday 28th February 2021)"
	revision: "9"

class
	MARKUP_SUBSTITUTION

inherit
	ANY

	EL_ZSTRING_CONSTANTS

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: ZSTRING)
		do
			delimiter_start := a_delimiter_start; delimiter_end := a_delimiter_end
			markup_open := a_markup_open; markup_close := a_markup_close
			new_expanded_link := agent empty_link
		end

feature -- Basic operations

	substitute_html (html: ZSTRING; new_link_agent: like new_expanded_link)
		do
			html.edit (delimiter_start, delimiter_end, agent expand_markup)
		end

feature -- Access

	delimiter_end: ZSTRING

	delimiter_start: ZSTRING

	markup_close: ZSTRING

	markup_open: ZSTRING

feature {NONE} -- Implementation

	empty_link (path, text: ZSTRING): ZSTRING
		do
			create Result.make_empty
		end

	expand_markup (start_index, end_index: INTEGER; substring: ZSTRING)
		do
			substring.replace_substring (markup_close, end_index + 1, substring.count)
			substring.replace_substring (markup_open, 1, start_index - 1)
		end

feature {NONE} -- Internal attributes

	new_expanded_link: FUNCTION [ZSTRING, ZSTRING, ZSTRING]

feature {NONE} -- Constants

	Square_bracket: TUPLE [left, right: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "[, ]")
		end

end