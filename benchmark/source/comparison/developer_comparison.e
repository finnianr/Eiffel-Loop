note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 9:49:17 GMT (Sunday 14th April 2024)"
	revision: "5"

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
			i: INTEGER
		do
			from  until i > 10_000 loop
				inspect id
					when 1 then

					when 2 then
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants


note
	notes: "[
		**13 April 2024**
		
		Method for ${EL_INTEGER_MATH}.natural_digit_count

		Passes over 500 millisecs (in descending order)

			quotient := quotient // 10 :  422.0 times (100%)
			{DOUBLE_MATH}.log10        :  196.0 times (-53.6%)

		**13 Dec 2023**

		Passes over 500 millisecs (in descending order)

			C_date: C_DATE; System_time: EL_SYSTEM_TIME

			System_time.update:	231.0 times (100%)
			C_date.update:			105.0 times (-54.5%)

	]"

end