note
	description: "String split iteration comparison"
	notes: "[
		Passes over 500 millisecs (in descending order)

			EL_SPLIT_ON_CHARACTER [STRING] : 1141.0 times (100%)
			EL_SPLIT_STRING_8_LIST         : 1093.0 times (-4.2%)
			{STRING}.split                 : 1002.0 times (-12.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-13 14:17:52 GMT (Monday 13th March 2023)"
	revision: "5"

class
	STRING_SPLIT_ITERATION_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "{STRING_8} split iteration methods"

feature -- Basic operations

	execute
		local
			csv_string: STRING
		do
			create csv_string.make (2000)
			across Start_value |..| (Start_value + 500) as n loop
				if not csv_string.is_empty then
					csv_string.append_character (',')
				end
				csv_string.append (n.item.to_hex_string)
			end
			compare ("compare count items", <<
				["{STRING}.split",						agent string_dot_split (csv_string, Op_count_items)],
				["EL_SPLIT_STRING_8_LIST", 			agent el_split_string_8_list (csv_string, Op_count_items)],
				["EL_SPLIT_ON_CHARACTER [STRING]",	agent el_split_on_character (csv_string, Op_count_items)]
			>>)
			compare ("compare find item", <<
				["{STRING}.split",						agent string_dot_split (csv_string, Op_find)],
				["EL_SPLIT_STRING_8_LIST", 			agent el_split_string_8_list (csv_string, Op_find)],
				["EL_SPLIT_ON_CHARACTER [STRING]",	agent el_split_on_character (csv_string, Op_find)]
			>>)
		end

feature {NONE} -- String split iteration

	el_split_on_character (csv_string: STRING; operation: INTEGER)
		local
			character_split: EL_SPLIT_ON_CHARACTER [STRING]
			count: INTEGER; found: BOOLEAN
		do
			create character_split.make (csv_string, ',')
			inspect operation
				when Op_count_items then
					across character_split as split loop
						count := count + 1
					end
				when Op_find then
					across character_split as split until found loop
						found := split.item_same_as (Four_hundred)
					end
			end
		end

	el_split_string_8_list (csv_string: STRING; operation: INTEGER)
		local
			list: EL_SPLIT_STRING_8_LIST
			count: INTEGER; found: BOOLEAN
		do
			create list.make (csv_string, ',')
			inspect operation
				when Op_count_items then
					from list.start until list.after loop
						count := count + 1
						list.forth
					end
				when Op_find then
					from list.start until found loop
						found := list.item_same_as (Four_hundred)
						list.forth
					end
			end
		end

	string_dot_split (csv_string: STRING; operation: INTEGER)
		local
			count: INTEGER; found: BOOLEAN
		do
			inspect operation
				when Op_count_items then
					across csv_string.split (',') as split loop
						count := count + 1
					end
				when Op_find then
					across csv_string.split (',') as split until found loop
						found := split.item ~ Four_hundred
					end
			end
		end

feature {NONE} -- Constants

	Start_value: INTEGER = 0xFFFF_FFFF

	Op_find: INTEGER = 1

	Op_count_items: INTEGER = 2

	Four_hundred: STRING
		once
			Result := (Start_value + 400).to_hex_string
		end

end