note
	description: "Summary description for {EL_SEARCH_ENGINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SEARCH_ENGINE [G -> EL_WORD_SEARCHABLE]

create
	make

feature {NONE} -- Initialization

	make (a_search_term_parser: like search_term_parser; a_list: like list)
		do
			search_term_parser := a_search_term_parser
			list := a_list
			create results.make (100)
		end

feature -- Basic operations

	search (str: STRING)
		local
			l_list: like list
			criteria: like search_term_parser.criteria
		do
			if not list.is_empty then
				search_term_parser.set_word_table (list.first.word_table)
			end
			search_term_parser.set_search_terms (str)
			results.wipe_out
			l_list := list
			if search_term_parser.is_valid then
				criteria := search_term_parser.criteria
				from l_list.start until l_list.after loop
					if criteria.for_all (agent {EL_SEARCH_TERM}.meets_criteria (l_list.item)) then
						results.extend (l_list.item)
					end
					l_list.forth
				end
			end
		end

feature -- Element change

	set_list (a_list: like list)
		do
			list := a_list
		end

feature -- Access

	results: ARRAYED_LIST [G]

	search_words: like search_term_parser.match_words
		do
			Result := search_term_parser.match_words
		end

feature {NONE} -- Implementation

	search_term_parser: EL_SEARCH_TERM_PARSER

	list: LIST [G]

end
