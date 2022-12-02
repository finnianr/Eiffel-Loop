note
	description: "Compare [$source STRING_8] item vs item_8"
	notes: "[
		Passes over 1000 millisecs (in descending order)
		
			iterate_with_item_8 :  9975.4 times (100%)
			iterate_with_item   :  3636.4 times (-63.5%)	
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-02 10:02:59 GMT (Friday 2nd December 2022)"
	revision: "9"

class
	STRING_ITEM_8_VS_ITEM

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		do
			compare ("compare_item", <<
				["iterate_with_item_8", 	agent iterate_with_item_8 (Hexagram.English_titles.joined_lines)],
				["iterate_with_item",		agent iterate_with_item (Hexagram.English_titles.joined_lines)]
			>>)
		end

feature {NONE} -- replace_substring_all

	iterate_with_item_8 (str: STRING)
		local
			i, count: INTEGER; c: CHARACTER
		do
			count := str.count
			from i := 1  until i > count loop
				c := str [i]
				i := i + 1
			end
		end

	iterate_with_item (str: READABLE_STRING_GENERAL)
		local
			i, count: INTEGER; c: CHARACTER_32
		do
			count := str.count
			from i := 1  until i > count loop
				c := str [i]
				i := i + 1
			end
		end

end