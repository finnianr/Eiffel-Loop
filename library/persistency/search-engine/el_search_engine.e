note
	description: "Search engine for word searchable `list' items conforming to [$source EL_WORD_SEARCHABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-09 11:41:33 GMT (Friday 9th November 2018)"
	revision: "6"

class
	EL_SEARCH_ENGINE [G -> EL_WORD_SEARCHABLE, P -> EL_SEARCH_TERM_PARSER [G] create make end]

create
	make

feature {NONE} -- Initialization

	make (a_list: like list)
		do
			list := a_list
			create parser.make
			create results.make_empty
		end

feature -- Basic operations

	do_query
		require
			valid_query: valid_query
		do
			if valid_query then
				results := list.query (parser.query_condition)
			else
				results.wipe_out
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
			parser.set_query_condition (query, word_table)
		end

feature -- Access

	results: like list.query

	match_words: like parser.match_words
		do
			Result := parser.match_words
		end

feature -- Status query

	valid_query: BOOLEAN
		do
			Result := parser.is_valid
		end

	invalid_wildcard: BOOLEAN
		-- True if parsed search term had an invalid wild card
		do
			Result := parser.invalid_wildcard
		end

feature {NONE} -- Implementation

	word_table: EL_WORD_TOKEN_TABLE
		do
			if list.is_empty then
				create Result.make (0)
			else
				Result := list.first.word_table
			end
		end

	list: EL_CHAIN [G]

	parser: P

end
