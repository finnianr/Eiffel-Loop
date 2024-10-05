note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "7"

class
	ARRAYED_INTERVAL_LIST_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Arrayed intervals INTEGER_64 vs INTEGER_32 x 2"

feature -- Basic operations

	execute
		local
			words: EL_SPLIT_ZSTRING_LIST
		do
			create words.make (Text.cyrillic_line, ' ')

			compare ("compare extend", <<
				["create intervals INTEGER_64", 	agent create_intervals_64 (words)],
				["create intervals INTEGER_32", 	agent create_intervals_32 (words)]
			>>)

			compare ("compare item_lower", <<
				["item_lower: INTEGER_32", 	agent iterate_over_lower_items_32 (new_intervals_32 (words))],
				["item_lower: INTEGER_64", 	agent iterate_over_lower_items_64 (new_intervals_64 (words))]
			>>)

			compare ("compare item_count", <<
				["item_count: INTEGER_32", 	agent iterate_over_count_items_32 (new_intervals_32 (words))],
				["item_count: INTEGER_64", 	agent iterate_over_count_items_64 (new_intervals_64 (words))]
			>>)
		end

feature {NONE} -- append_character

	create_intervals_32 (words: EL_SPLIT_ZSTRING_LIST)
		do
			if attached new_intervals_32 (words) as list then
				do_nothing
			end
		end

	create_intervals_64 (words: EL_SPLIT_ZSTRING_LIST)
		do
			if attached new_intervals_64 (words) as list then
				do_nothing
			end
		end

	iterate_over_count_items_32 (list: EL_ARRAYED_INTERVAL_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item_count
				list.forth
			end
		end

	iterate_over_count_items_64 (list: EL_ARRAYED_COMPACT_INTERVAL_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item_count
				list.forth
			end
		end

	iterate_over_lower_items_32 (list: EL_ARRAYED_INTERVAL_LIST)
		local
			lower: INTEGER
		do
			from list.start until list.after loop
				lower := list.item_lower
				list.forth
			end
		end

	iterate_over_lower_items_64 (list: EL_ARRAYED_COMPACT_INTERVAL_LIST)
		local
			lower: INTEGER
		do
			from list.start until list.after loop
				lower := list.item_lower
				list.forth
			end
		end

feature {NONE} -- Implementation

	new_intervals_32 (words: EL_SPLIT_ZSTRING_LIST): EL_ARRAYED_INTERVAL_LIST
		do
			create Result.make (words.count)
			if attached words as str then
				from str.start until str.after loop
					Result.extend (str.item_lower, str.item_upper)
					str.forth
				end
			end
		end

	new_intervals_64 (words: EL_SPLIT_ZSTRING_LIST): EL_ARRAYED_COMPACT_INTERVAL_LIST
		do
			create Result.make (words.count)
			if attached words as str then
				from str.start until str.after loop
					Result.extend (str.item_lower, str.item_upper)
					str.forth
				end
			end
		end
end