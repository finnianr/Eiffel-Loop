note
	description: "Replace substring comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:27:49 GMT (Saturday 1st February 2020)"
	revision: "3"

class
	REPLACE_SUBSTRING_COMPARISON

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
			str.replace_substring_all (new_zstring (Chinese [1]), new_zstring (Chinese [2]))
		end

	replace_substring_general_all
		local
			str: ZSTRING
		do
			str := Hexagram_1_description
			str.replace_substring_general_all (Chinese [1], Chinese [2])
		end

end
