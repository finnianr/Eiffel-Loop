note
	description: "[
		The same as class [$source EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS] except result items `G' 
		that additionally conform to [$source EL_DATEABLE] will have a date is displayed in the search results
		by prepending to search match extract quotes.
	]"
	notes: "[
		**Compiler Bug 16.05**
		
		Defining this class using this construct
			
			EL_SCROLLABLE_DATEABLE_SEARCHABLE_RESULTS [G -> {EL_WORD_SEARCHABLE, EL_DATEABLE}]
			
		causes the compiler to crash while generating the C code for this class. Used casting as a workaround.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-26 14:07:56 GMT (Friday 26th February 2021)"
	revision: "5"

class
	EL_SCROLLABLE_DATEABLE_WORD_SEARCHABLE_RESULTS [G -> EL_WORD_SEARCHABLE]

inherit
	EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS [G]
		redefine
			new_word_match_extract_lines
		end

create
	make, default_create

feature {NONE} -- Implementation

	new_formatted_date (date: DATE): STRING
		do
			Result := Locale.date_text.formatted (date, style.date_format)
		end

	new_word_match_extract_lines (result_item: G): LIST [EL_STYLED_TEXT_LIST [STRING_GENERAL]]
		local
			date_line: EL_STYLED_STRING_8_LIST
		do
			Result := result_item.word_match_extracts (search_words)
			if attached {EL_DATEABLE} result_item as l_item then
				if Result.is_empty then
					create date_line.make (1)
					date_line.extend ({EL_TEXT_STYLE}.Regular, new_formatted_date (l_item.date))
					Result.extend (date_line)
				else
					Result.first.put_front ({EL_TEXT_STYLE}.Regular, new_formatted_date (l_item.date))
				end
			end
		end

end