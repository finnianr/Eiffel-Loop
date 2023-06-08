note
	description: "[
		The same as class [$source EL_SCROLLABLE_SEARCH_RESULTS] except result items `G' 
		additionally conform to [$source EL_WORD_SEARCHABLE] and search results
		display search match extract quotes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-08 10:06:53 GMT (Thursday 8th June 2023)"
	revision: "8"

class
	EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS [G -> EL_WORD_SEARCHABLE]

inherit
	EL_SCROLLABLE_SEARCH_RESULTS [G]
		redefine
			make_default, new_detail_lines
		end

create
	make, default_create

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create search_words.make (0)
		end

feature -- Element change

	set_search_words (a_search_words: like search_words)
		do
			search_words := a_search_words
		end

feature {NONE} -- Factory

	new_detail_lines (result_item: G): ARRAYED_LIST [EL_STYLED_TEXT_LIST [STRING_GENERAL]]
		do
			Result := result_item.word_match_extracts (search_words)
		end

feature {NONE} -- Implementation: attributes

	search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]

end