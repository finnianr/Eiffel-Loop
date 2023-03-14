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
	date: "2023-03-14 17:39:39 GMT (Tuesday 14th March 2023)"
	revision: "12"

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
			str := hexagram_1_title
			str.replace_substring_all (Hanzi_strings [1], Hanzi_strings [2])
		end

	replace_substring_general_all
		local
			str: ZSTRING
		do
			str := hexagram_1_title
			str.replace_substring_all (Hanzi_strings_32 [1], Hanzi_strings_32 [2])
		end

end