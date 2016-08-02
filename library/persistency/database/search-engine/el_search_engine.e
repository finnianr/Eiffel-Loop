note
	description: "Summary description for {EL_SEARCH_ENGINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 10:17:23 GMT (Wednesday 13th January 2016)"
	revision: "1"

class
	EL_SEARCH_ENGINE [G -> EL_WORD_SEARCHABLE]

create
	make

feature {NONE} -- Initialization

	make (a_parser: like parser; a_list: like list)
		do
			parser := a_parser; list := a_list
			create results.make (100)
		end

feature -- Basic operations

	do_query
		require
			valid_query: valid_query
		local
			l_list: like list; criteria: like parser.criteria
		do
			results.wipe_out
			l_list := list; criteria := parser.criteria
			from l_list.start until l_list.after loop
				if across criteria as criterion all
						criterion.item.matches (l_list.item)
					end
				then
					results.extend (l_list.item)
				end
				l_list.forth
			end
		end

	search (query: ZSTRING)
		do
			set_query (query)
			if valid_query then
				do_query
			end
		end

feature -- Element change

	set_list (a_list: like list)
		do
			list := a_list
		end

	set_query (query: ZSTRING)
		do
			if not list.is_empty then
				parser.set_word_table (list.first.word_table)
			end
			query.left_adjust; query.right_adjust
			parser.set_search_terms (query)
		end

feature -- Access

	parser: EL_SEARCH_TERM_PARSER

	results: ARRAYED_LIST [G]

feature -- Status query

	valid_query: BOOLEAN
		do
			Result := parser.is_valid
		end

feature {NONE} -- Implementation

	list: LIST [G]

end