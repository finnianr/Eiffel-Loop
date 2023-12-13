note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-13 17:46:42 GMT (Wednesday 13th December 2023)"
	revision: "1"

class
	DEVELOPER_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

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
		do
			across 1 |..| 10000 as n loop
				inspect id
					when 1 then
						C_date.update

					when 2 then
						System_time.update
				end
			end
		end

feature {NONE} -- Constants

	C_date: C_DATE
		once
			create Result.make_utc
		end

	System_time: EL_SYSTEM_TIME
		once
			create Result.make_utc
		end

note
	notes: "[
		**13 Dec 2023**
		
		Passes over 500 millisecs (in descending order)

			System_time.update:	231.0 times (100%)
			C_date.update:			105.0 times (-54.5%)

	]"

end