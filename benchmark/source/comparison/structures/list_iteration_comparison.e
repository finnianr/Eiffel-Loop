note
	description: "Compare 8 ways to iterate over an ${ARRAYED_LIST} to calculate an integer sum"
	notes: "[
		Passes over 500 millisecs (in descending order)

			SPECIAL i := 0 until i = area.count     : 105492.0 times (100%)
			SPECIAL i := 0 until i > i_upper        : 104798.0 times (-0.7%)
			SPECIAL i := 0 until i = count          : 103620.0 times (-1.8%)
			from i := 1 until i > count loop        :  10524.0 times (-90.0%)
			array.do_all (agent increment (sum, ?)) :  10389.0 times (-90.2%)
			from array.start until array.after loop :   9044.0 times (-91.4%)
			across array as n loop                  :   6020.0 times (-94.3%)
			from i := 1 until i > array.count loop  :   5225.0 times (-95.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 14:01:23 GMT (Monday 12th May 2025)"
	revision: "11"

class
	LIST_ITERATION_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Access

	Description: STRING = "8 ways to iterate over ARRAYED_LIST"

feature -- Basic operations

	execute
		local
			array: ARRAYED_LIST [INTEGER]; i: INTEGER; sum: INTEGER_REF
		do
			create array.make_filled (2000)
			from i := 1 until i > array.count loop
				array [i] := i
				i := i + 1
			end
			create sum
			compare ("compare_list_iteration_methods", <<
				["SPECIAL i := 0 until i = count",				agent special_from_i_until_count (array.area, sum)],
				["SPECIAL i := 0 until i > i_upper",			agent special_from_i_until_gt_i_upper (array.area, sum)],
				["SPECIAL i := 0 until i = area.count",		agent special_from_i_until_array_count (array.area, sum)],

				["from i := 1 until i > count loop",			agent from_i_until_count (array, sum)],
				["from i := 1 until i > array.count loop", 	agent from_i_until_array_count (array, sum)],
				["from array.start until array.after loop",  agent start_after_forth (array, sum)],
				["across array as n loop",							agent across_array_as_n (array, sum)],
				["array.do_all (agent increment (sum, ?))",	agent do_all (array, sum)]
			>>)
		end

feature {NONE} -- Iteration variations

	across_array_as_n (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			across array as n loop
				sum.set_item (sum.item + n.item)
			end
		end

	do_all (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			array.do_all (agent increment (sum, ?))
		end

	from_i_until_count (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			count := array.count
			from i := 1 until i > count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	from_i_until_array_count (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		local
			i: INTEGER
		do
			sum.set_item (0)
			from i := 1 until i > array.count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	special_from_i_until_count (area: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0)
			count := area.count
			from i := 0 until i = count loop
				sum.set_item (sum.item + area [i])
				i := i + 1
			end
		end

	special_from_i_until_gt_i_upper (area: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i, i_upper: INTEGER
		do
			sum.set_item (0)
			i_upper := area.count - 1
			from i := 0 until i > i_upper loop
				sum.set_item (sum.item + area [i])
				i := i + 1
			end
		end

	special_from_i_until_array_count (area: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i: INTEGER
		do
			sum.set_item (0)
			from i := 0 until i = area.count loop
				sum.set_item (sum.item + area [i])
				i := i + 1
			end
		end

	start_after_forth (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			from array.start until array.after loop
				sum.set_item (sum.item + array.item)
				array.forth
			end
		end

feature {NONE} -- Implementation

	increment (a_sum: INTEGER_REF; n: INTEGER)
		do
			a_sum.set_item (a_sum.item + n)
		end

end