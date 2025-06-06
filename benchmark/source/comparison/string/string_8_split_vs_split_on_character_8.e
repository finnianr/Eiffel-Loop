note
	description: "[
		Compare parsing comma separated list of reals using across iteration over:

		1. ${STRING_8}.split
		2. ${EL_SPLIT_ON_CHARACTER_8 [READABLE_STRING_8]}
	]"
	notes: "[
		RESULTS: Sum reals in CSV string
		Passes over 500 millisecs (in descending order)

			EL_SPLIT_ON_CHARACTER_8 :  787.0 times (100%)
			STRING_8.split          :  510.0 times (-35.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 9:28:54 GMT (Thursday 17th April 2025)"
	revision: "11"

class
	STRING_8_SPLIT_VS_SPLIT_ON_CHARACTER_8

inherit
	EL_BENCHMARK_COMPARISON

	DOUBLE_MATH

create
	make

feature -- Access

	Description: STRING = "Parsing reals with STRING_8.split VS EL_SPLIT_ON_CHARACTER_8"

feature -- Basic operations

	execute
		local
			list: EL_STRING_8_LIST; csv_values: STRING
		do
			create list.make (500)
			from  until list.full loop
				list.extend ((Pi * list.count * 1).out)
			end
			csv_values := list.joined (',')
			compare ("Sum reals in CSV string", <<
				["STRING_8.split",			 agent string_8_split (csv_values)],
				["EL_SPLIT_ON_CHARACTER_8", agent split_on_character_8 (csv_values)]
			>>)
		end

feature {NONE} -- el_os_routines_i

	split_on_character_8 (csv_values: STRING)
		local
			sum: DOUBLE; comma_split: EL_SPLIT_ON_CHARACTER_8 [STRING_8]
		do
			create comma_split.make (csv_values, ',')
			across comma_split as value loop
				sum := sum + value.item.to_double
			end
		end

	string_8_split (csv_values: STRING)
		local
			sum: DOUBLE
		do
			across csv_values.split (',') as value loop
				sum := sum + value.item.to_double
			end
		end

end