note
	description: "Substring index comparison"
	notes: "[

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-19 17:44:38 GMT (Sunday 19th February 2023)"
	revision: "11"

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
				["substring_index ({ZSTRING})", 		agent substring_index_1 (new_zstring (Chinese [1]))],
				["substring_index ({STRING_32})",	agent substring_index_2 (Chinese [1])]
			>>)
		end

feature {NONE} -- substring_index

	substring_index_1 (str: ZSTRING)
		local
			pos: INTEGER
		do
			pos := Hexagram_1_description.substring_index (str, 1)
		end

	substring_index_2 (str: STRING_32)
		local
			pos: INTEGER
		do
			pos := Hexagram_1_description.substring_index (str, 1)
		end

end