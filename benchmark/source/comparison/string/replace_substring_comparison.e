note
	description: "Replace substring comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 10:22:39 GMT (Tuesday 6th April 2021)"
	revision: "5"

class
	REPLACE_SUBSTRING_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		do
			compare ("compare_replace_substring", 1000, <<
				["replace_substring_general_all", 	agent replace_substring_general_all],
				["replace_substring_all",				agent replace_substring_all]
			>>)
		end

feature {NONE} -- replace_substring_all

	replace_substring_all
		local
			str: ZSTRING
		do
			str := Hexagram_1_description
			str.replace_substring_all (Chinese_1, Chinese_2)
		end

	replace_substring_general_all
		local
			str: ZSTRING
		do
			str := Hexagram_1_description
			str.replace_substring_general_all (Chinese [1], Chinese [2])
		end

feature {NONE} -- Constants

	Chinese_1: ZSTRING
		once
			Result := Chinese [1]
		end

	Chinese_2: ZSTRING
		once
			Result := Chinese [2]
		end
end