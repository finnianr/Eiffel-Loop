note
	description: "Substring index comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:27:51 GMT (Saturday 1st February 2020)"
	revision: "3"

class
	SUBSTRING_INDEX_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		do
			compare ("compare_substring_index", <<
				["substring_index", 						agent substring_index],
				["substring_index_general",			agent substring_index_general]
			>>)
		end

feature {NONE} -- substring_index

	substring_index
		local
			str: ZSTRING; pos: INTEGER
		do
			str := Hexagram_1_description
			pos := str.substring_index (new_zstring (Chinese [1]), 1)
		end

	substring_index_general
		local
			str: ZSTRING; pos: INTEGER
		do
			str := Hexagram_1_description
			pos := str.substring_index_general (Chinese [1], 1)
		end

end
