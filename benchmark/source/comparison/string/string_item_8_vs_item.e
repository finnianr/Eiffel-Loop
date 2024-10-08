note
	description: "Compare `${STRING_8}.item' VS `character_32_item'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "17"

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
		do
			compare ("compare_item", <<
				["iterate_with_item_8", agent iterate_with_item_8 (Big_string)],
				["iterate_with_item",	agent iterate_with_item (Big_string)]
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