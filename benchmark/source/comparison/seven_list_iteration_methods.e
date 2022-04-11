note
	description: "Compare various ways of iterating a list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-11 9:15:52 GMT (Monday 11th April 2022)"
	revision: "6"

class
	SEVEN_LIST_ITERATION_METHODS

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Basic operations

	execute
		local
			array: ARRAYED_LIST [INTEGER]; i: INTEGER; sum: INTEGER_REF
		do
			create array.make_filled (1000)
			from i := 1 until i > array.count loop
				array [i] := i
				i := i + 1
			end
			create sum
			compare ("compare_list_iteration_methods", <<
				["SPECIAL i := 0 until i = count",				agent special_from_i_until_count (array.area, sum)],
				["SPECIAL i := 0 until i = array.count",		agent special_from_i_until_array_count (array.area, sum)],
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

	special_from_i_until_count (array: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0)
			count := array.count
			from i := 0 until i = count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	special_from_i_until_array_count (array: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i: INTEGER
		do
			sum.set_item (0)
			from i := 0 until i = array.count loop
				sum.set_item (sum.item + array [i])
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