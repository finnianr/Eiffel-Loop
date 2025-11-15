note
	description: "[
		RESULTS: internal_search
		Passes over 1000 millisecs (in descending order)

			STRING_TABLE [STRING] :  9461.0 times (100%)
			EL_HASH_SET [STRING]  :  6860.0 times (-27.5%)

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-13 17:12:52 GMT (Thursday 13th November 2025)"
	revision: "2"

class
	SEARCH_TABLE_VS_HASH_SET_SEARCH

inherit
	EL_BENCHMARK_COMPARISON

	SHARED_HEXAGRAM_STRINGS

create
	make

feature -- Access

	Description: STRING = "SEARCH_TABLE VS EL_HASH_SET for internal_search"

feature -- Basic operations

	execute
		local
			word_list: EL_STRING_8_LIST
		do
			create word_list.make (1000)
			across Hexagram.English_titles as title loop
				word_list.append_sequence (title.item.split (' '))
			end
			compare ("internal_search VS set_position", <<
				["EL_HASH_SET [STRING]",	agent put_into_set (word_list)],
				["SEARCH_TABLE [STRING]",	agent put_into_table (word_list)]
			>>)
		end

feature {NONE} -- Implementation

	put_into_set (word_list: EL_STRING_8_LIST)
		local
			set: EL_HASH_SET [STRING]
		do
			create set.make_equal (word_list.count)
			across word_list as list loop
				set.put (list.item)
			end
		end

	put_into_table (word_list: EL_STRING_8_LIST)
		local
			set: SEARCH_TABLE [STRING]
		do
			create set.make (word_list.count)
			across word_list as list loop
				set.put (list.item)
			end
		end
end