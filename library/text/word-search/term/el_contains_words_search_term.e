note
	description: "Summary description for {CONTAINS_WORDS_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-16 9:59:18 GMT (Sunday 16th March 2014)"
	revision: "2"

class
	EL_CONTAINS_WORDS_SEARCH_TERM

inherit
	EL_SEARCH_TERM

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

feature -- Status report

	matches (target: like Type_target): BOOLEAN
			--
		do
			if words.count = 1 then
				Result := target.searchable_words.has (words [1])
			else
				Result := searcher.index (target.searchable_words, 1) > 0
			end
		end

feature {NONE} -- Implementation

	searcher: EL_BOYER_MOORE_SEARCHER_32

end
