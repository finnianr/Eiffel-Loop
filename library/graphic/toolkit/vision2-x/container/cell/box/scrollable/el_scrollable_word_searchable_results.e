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
	date: "2021-02-24 11:48:40 GMT (Wednesday 24th February 2021)"
	revision: "2"

class
	EL_SCROLLABLE_WORD_SEARCHABLE_RESULTS [G -> {EL_HYPERLINKABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SCROLLABLE_SEARCH_RESULTS [G]
		rename
			add_supplementary as add_match_extracts
		redefine
			add_match_extracts, make, new_result_link_box
		end

create
	make, default_create

feature {NONE} -- Initialization

	make (a_result_selected_action: like result_selected_action; a_links_per_page: INTEGER; a_font_table: EL_FONT_SET)
		do
			Precursor (a_result_selected_action, a_links_per_page, a_font_table)
			create search_words.make (0)
		end

feature -- Element change

	set_search_words (a_search_words: like search_words)
		do
			search_words := a_search_words
		end

feature {NONE} -- Factory

	new_result_link_box (result_item: G; i: INTEGER): EL_BOX
		do
			Result := Precursor (result_item, i)
			add_supplementary (Result, result_item, i)
		end

	new_word_match_extract_lines (result_item: G): LIST [EL_STYLED_TEXT_LIST [READABLE_STRING_GENERAL]]
		do
			Result := result_item.word_match_extracts (search_words)
		end

feature {NONE} -- Implementation

	add_match_extracts (result_link_box: EL_BOX; result_item: G; i: INTEGER)
		-- add word match extract quotes for `i' th `result_item' to `result_link_box'
		local
			style_labels: EL_MIXED_STYLE_FIXED_LABELS
		do
			create style_labels.make_with_styles (
				new_word_match_extract_lines (result_item), details_indent, font_table, background_color
			)
			result_link_box.extend_unexpanded (style_labels)
		end

	add_supplementary (result_link_box: EL_BOX; result_item: G; i: INTEGER)
		-- add supplementary information for `i' th `result_item' to `result_link_box'
		do
		end

feature {NONE} -- Implementation: attributes

	search_words: ARRAYED_LIST [EL_WORD_TOKEN_LIST]

end