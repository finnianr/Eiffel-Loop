note
	description: "[
		Replace substrings between delimiters with faux HTML markup.
		Faux markup is made real by translating with characters from `Html_reserved' before
		doing XML escaping.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-06 16:52:33 GMT (Saturday 6th April 2024)"
	revision: "19"

class
	MARKUP_SUBSTITUTION

inherit
	ANY

	EL_MODULE_TUPLE

	EL_STRING_GENERAL_ROUTINES

	EL_ZSTRING_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: READABLE_STRING_GENERAL)
		do
			delimiter_start := as_zstring (a_delimiter_start); delimiter_end := as_zstring (a_delimiter_end)
			markup_open := new_faux_markup (a_markup_open); markup_close := new_faux_markup (a_markup_close)
			create relative_page_dir
		end

feature -- Basic operations

	substitute_html (html_string: ZSTRING)
		do
			html_string.edit (delimiter_start, delimiter_end, agent expand_markup)
		end

feature -- Element change

	set_relative_page_dir (a_relative_page_dir: DIR_PATH)
		do
			relative_page_dir := a_relative_page_dir
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

	new_faux_markup (markup: READABLE_STRING_GENERAL): ZSTRING
		-- faux HTML markup with `Html_reserved' characters replaced with temporary control characters
		do
			Result := as_zstring (markup)
			Result.hide (Html_reserved)
		end

feature {NONE} -- Internal attributes

	relative_page_dir: DIR_PATH
		-- class page relative to index page directory tree

feature {NONE} -- Constants

	Html_link_template: ZSTRING
		once
			Result := new_faux_markup ("[
				<a href="#"# target="_blank">#</a>
			]")
		ensure
			three_markers: Result.occurrences ('%S') = 3
		end

end