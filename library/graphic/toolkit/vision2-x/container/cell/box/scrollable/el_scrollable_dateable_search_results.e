note
	description: "[
		The same as class [$source EL_SCROLLABLE_SEARCH_RESULTS] except result items `G' additionally conform to
		[$source EL_DATEABLE] and a date is displayed in the search results by prepending to search match
		extract quotes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-24 11:05:38 GMT (Wednesday 24th February 2021)"
	revision: "1"

class
	EL_SCROLLABLE_DATEABLE_SEARCH_RESULTS [G -> {EL_HYPERLINKABLE, EL_DATEABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SCROLLABLE_SEARCH_RESULTS [G]
		redefine
			make, new_word_match_extract_lines
		end

	EL_DATE_FORMATS
		rename
			short_canonical as date_short_canonical,
			canonical as date_canonical
		export
			{NONE} all
			{ANY} Date_formats
		undefine
			is_equal, copy, default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_result_selected_action: like result_selected_action; a_links_per_page: INTEGER; a_font_table: EL_FONT_SET)
		do
			Precursor (a_result_selected_action, a_links_per_page, a_font_table)
			set_default_date_format
		end

feature -- Element change

	set_date_format (a_date_format: like date_format)
		require
			valid_format: not a_date_format.is_empty implies Date_formats.has (a_date_format)
		do
			date_format := a_date_format
		end

	set_default_date_format
		do
			set_date_format (Dd_mmm_yyyy)
		end

feature {NONE} -- Implementation

	new_formatted_date (date: DATE): STRING
		do
			Result := Locale.date_text.formatted (date, date_format)
		end

	new_word_match_extract_lines (result_item: G): LIST [EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]]
		local
			date_line: EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]
		do
			Result := result_item.word_match_extracts (search_words)
			if Result.is_empty then
				create date_line.make (1); date_line.extend ({EL_TEXT_STYLE}.Regular, new_formatted_date (result_item.date))
				Result.extend (date_line)
			else
				Result.first.put_front ({EL_TEXT_STYLE}.Regular, new_formatted_date (result_item.date))
			end
		end

feature {NONE} -- Internal attributes

	date_format: STRING

end