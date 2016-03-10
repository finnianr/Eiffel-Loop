note
	description: "[
		Matches word token search string with any of the ending variations (last token)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 10:16:43 GMT (Wednesday 13th January 2016)"
	revision: "3"

class
	EL_ONE_OF_WORDS_SEARCH_TERM

inherit
	EL_CONTAINS_WORDS_SEARCH_TERM
		rename
			make as make_contains,
			words as phrase_stem,
			searcher as phrase_stem_searcher
		redefine
			positive_match
		end

create
	make

feature {NONE} -- Initialization

	make (a_phrase_stem, a_ending_variations: EL_TOKENIZED_STRING)
			--
		do
			make_contains (a_phrase_stem)
			ending_variations := a_ending_variations
		end

feature -- Access

	ending_variations: EL_TOKENIZED_STRING
		-- list of possible last phrase token variations

feature {NONE} -- Implementation

	positive_match (target: like Type_target): BOOLEAN
			--
		local
			phrase_stem_word_count, start_index, i: INTEGER
			l_searchable_words, endings: EL_TOKENIZED_STRING
			word_token: CHARACTER_32; stem_searcher: like phrase_stem_searcher
		do
			l_searchable_words := target.searchable_words
			endings := ending_variations
			if phrase_stem.is_empty then
				from i := 1 until Result or i > endings.count loop
					Result := l_searchable_words.has (endings [i])
					i := i + 1
				end
			else
				stem_searcher := phrase_stem_searcher
				word_token := phrase_stem [1]
				phrase_stem_word_count := phrase_stem.count
				from start_index := 1 until Result or start_index = 0 loop
					if phrase_stem_word_count = 1 then
						start_index := l_searchable_words.index_of (word_token, start_index)
					else
						start_index := stem_searcher.index (l_searchable_words, start_index)
					end
					-- IF target contains phrase stem
					if start_index > 0 then
						start_index := start_index + phrase_stem_word_count
						if start_index > l_searchable_words.count then
							start_index := 0

						else -- IF token just after matched phrase stem matches a variation
							Result := endings.has (l_searchable_words [start_index])
						end
					end
				end
			end
		end

end
