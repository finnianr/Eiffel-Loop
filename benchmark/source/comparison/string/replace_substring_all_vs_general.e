note
	description: "Replace substring comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-11 9:28:39 GMT (Monday 11th April 2022)"
	revision: "7"

class
	REPLACE_SUBSTRING_ALL_VS_GENERAL

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

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