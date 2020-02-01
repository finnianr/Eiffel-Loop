note
	description: "Compare various ways of iterating a list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:27:41 GMT (Saturday 1st February 2020)"
	revision: "2"

class
	LIST_ITERATION_COMPARISON

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
			create array.make_filled (Iteration_count)
			from i := 1 until i > array.count loop
				array [i] := i
				i := i + 1
			end
			create sum
			compare ("compare_list_iteration_methods", <<
				["SPECIAL from i := 0 until i = count loop", agent iterate_special_from_i_until_i_eq_count (array.area, True, sum)],
				["SPECIAL from i := 0 until i = array.count loop", agent iterate_special_from_i_until_i_eq_count (array.area, False, sum)],
				["from i := 1 until i > count loop",			agent iterate_from_i_until_i_gt_count (array, True, sum)],
				["from i := 1 until i > array.count loop", 	agent iterate_from_i_until_i_gt_count (array, False, sum)],
				["from array.start until array.after loop",  agent iterate_start_after_forth (array, sum)],
				["across array as n loop",							agent iterate_across_array_as_n (array, sum)],
				["array.do_all (agent increment (sum, ?))",	agent iterate_do_all (array, sum)]
			>>)
		end

feature {NONE} -- Iteration variations

	iterate_across_array_as_n (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			across array as n loop
				sum.set_item (sum.item + n.item)
			end
		end

	iterate_do_all (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			array.do_all (agent increment (sum, ?))
		end

	iterate_from_i_until_i_gt_count (array: ARRAYED_LIST [INTEGER]; local_count: BOOLEAN; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0)
			if local_count then
				count := array.count
				from i := 1 until i > count loop
					sum.set_item (sum.item + array [i])
					i := i + 1
				end
			else
				from i := 1 until i > array.count loop
					sum.set_item (sum.item + array [i])
					i := i + 1
				end
			end
		end

	iterate_special_from_i_until_i_eq_count (array: SPECIAL [INTEGER]; local_count: BOOLEAN; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0)
			if local_count then
				count := array.count
				from i := 0 until i = count loop
					sum.set_item (sum.item + array [i])
					i := i + 1
				end
			else
				from i := 0 until i = array.count loop
					sum.set_item (sum.item + array [i])
					i := i + 1
				end
			end
		end

	iterate_start_after_forth (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
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

feature {NONE} -- Constants

	Iteration_count: INTEGER
		once
			Result := new_iteration_count (1000_000)
		end

end
