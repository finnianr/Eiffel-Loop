note
	description: "Contains words search term"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-08 20:23:37 GMT (Thursday 8th November 2018)"
	revision: "6"

class
	EL_CONTAINS_WORDS_CONDITION [G -> EL_WORD_SEARCHABLE]

inherit
	EL_QUERY_CONDITION [G]

create
	make

feature {NONE} -- Initialization

	make (a_words: EL_TOKENIZED_STRING)
			--
		do
			words := a_words
			if words.is_empty then
				create searcher.make ("***")
			else
				create searcher.make (words)
			end
		end

feature -- Access

	words: EL_TOKENIZED_STRING

feature -- Status query

	met (item: G): BOOLEAN
			--
		do
			if words.count = 1 then
				Result := item.searchable_words.has (words [1])
			else
				Result := searcher.index (item.searchable_words, 1) > 0
			end
		end

feature {NONE} -- Implementation

	searcher: EL_BOYER_MOORE_SEARCHER_32

end
