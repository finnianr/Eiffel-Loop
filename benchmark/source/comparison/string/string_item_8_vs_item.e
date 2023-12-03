note
	description: "Compare {[$source STRING_8]}.item VS character_32_item"
	notes: "[
		Passes over 500 millisecs (in descending order)

			iterate_with_item_8 : 190267.0 times (100%)
			iterate_with_item   :   2862.0 times (-98.5%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-03 13:23:27 GMT (Sunday 3rd December 2023)"
	revision: "14"

class
	STRING_ITEM_8_VS_ITEM

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "STRING_8 item vs item_8"

feature -- Basic operations

	execute
		local
			big_string: STRING
		do
			big_string := Hexagram.English_titles.joined_lines
			compare ("compare_item", <<
				["iterate_with_item_8", agent iterate_with_item_8 (big_string)],
				["iterate_with_item",	agent iterate_with_item (big_string)]
			>>)
		end

feature {NONE} -- replace_substring_all

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

end