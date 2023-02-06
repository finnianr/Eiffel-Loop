note
	description: "Replace substring comparison"
	notes: "[
		Passes over 500 millisecs (in descending order)

			replace_substring_all         :  52352.0 times (100%)
			replace_substring_general_all :  38986.0 times (-25.5%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-06 14:15:14 GMT (Monday 6th February 2023)"
	revision: "10"

class
	REPLACE_SUBSTRING_ALL_VS_GENERAL

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "{ZSTRING}.replace_substring"

feature -- Basic operations

	execute
		do
			compare ("compare_replace_substring", <<
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