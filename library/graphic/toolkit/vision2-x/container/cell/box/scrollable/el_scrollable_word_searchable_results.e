note
	description: "[
		The same as class [$source EL_SCROLLABLE_SEARCH_RESULTS] except result items `G' 
		additionally conform to [$source EL_WORD_SEARCHABLE] and search results
		display search match extract quotes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-27 13:26:52 GMT (Saturday 27th February 2021)"
	revision: "5"

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
		local
			date_line: EL_STYLED_TEXT_LIST [STRING_GENERAL]
		do
			Result := Precursor (result_item)
			if Result.is_empty then -- No date present
				Result := result_item.word_match_extracts (search_words)

			elseif Result.count = 1 then -- has date
				across result_item.word_match_extracts (search_words) as line loop
					if line.cursor_index = 1 then
						-- append first line of match extracts to date
						date_line := line.item
						from date_line.start until date_line.after loop
							Result.first.extend (date_line.item_style, date_line.item_text)
							date_line.forth
						end
					else
						Result.extend (line.item)
					end
				end
			else
				Result.append (result_item.word_match_extracts (search_words))
			end
		end

feature {NONE} -- Implementation: attributes

	search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]

end