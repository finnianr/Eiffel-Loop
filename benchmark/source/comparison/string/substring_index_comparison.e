note
	description: "Substring index comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-14 17:39:39 GMT (Tuesday 14th March 2023)"
	revision: "12"

class
	SUBSTRING_INDEX_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "{ZSTRING}.substring_index (s: STRING_32/ZSTRING)"

feature -- Basic operations

	execute

		do
			compare ("compare_substring_index", <<
				["substring_index ({ZSTRING})", 		agent substring_index_1 (Hanzi_strings [1])],
				["substring_index ({STRING_32})",	agent substring_index_2 (Hanzi_strings_32 [1])]
			>>)
		end

feature {NONE} -- substring_index

	substring_index_1 (str: ZSTRING)
		local
			pos: INTEGER
		do
			pos := hexagram_1_title.substring_index (str, 1)
		end

	substring_index_2 (str: STRING_32)
		local
			pos: INTEGER
		do
			pos := hexagram_1_title.substring_index (str, 1)
		end

end