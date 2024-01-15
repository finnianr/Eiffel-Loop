note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-15 11:32:59 GMT (Monday 15th January 2024)"
	revision: "3"

class
	DEVELOPER_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	TIME_CONSTANTS

create
	make

feature -- Access

	Description: STRING = "Development method comparisons"

feature -- Basic operations

	execute
		do
			compare ("perform benchmark", <<
				["method 1", agent do_method (1)],
				["method 2", agent do_method (2)]
			>>)
		end

feature {NONE} -- Operations

	do_method (id: INTEGER)
		local
			day_milliseconds: INTEGER
		do
			across 1 |..| 10000 as n loop
				inspect id
					when 1 then

					when 2 then
				end
			end
		end

feature {NONE} -- Constants


note
	notes: "[
		**13 Dec 2023**
		
		Passes over 500 millisecs (in descending order)
		
			C_date: C_DATE; System_time: EL_SYSTEM_TIME

			System_time.update:	231.0 times (100%)
			C_date.update:			105.0 times (-54.5%)

	]"

end