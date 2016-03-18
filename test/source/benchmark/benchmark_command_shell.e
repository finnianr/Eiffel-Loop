note
	description: "Summary description for {EL_BENCHMARK_COMMAND_SHELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-18 18:24:19 GMT (Friday 18th March 2016)"
	revision: "5"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_LINE_SUB_APPLICATION} make
		end

create
	default_create, make

feature -- Basic operations

	compare_list_iteration_methods
		local
			actions: like Type_actions; array: ARRAYED_LIST [INTEGER]
			i: INTEGER; sum: INTEGER_REF
		do
			log.enter ("compare_list_iteration_methods")
			create array.make_filled (10000)
			create sum
			create actions.make (<<
				["SPECIAL from i := 0 until i = count loop", agent iterate_special_from_i_until_i_eq_count (array.area, sum)],
				["from i := 1 until i > array.count loop", 	agent iterate_from_i_until_i_gt_count (array, sum)],
				["from array.start until array.after loop", 	agent iterate_start_after_forth (array, sum)],
				["across array as number loop",					agent iterate_across_array_as_n (array, sum)],
				["array.do_all (agent increment (sum, ?))",	agent iterate_do_all (array, sum)]
			>>)
			compare_benchmarks (actions)
			log.exit
		end

feature {NONE} -- Iteration variations

	iterate_across_array_as_n (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			across array as number loop
				sum.set_item (sum.item + number.item)
			end
		end

	iterate_special_from_i_until_i_eq_count (array: SPECIAL [INTEGER]; sum: INTEGER_REF)
		local
			i, count: INTEGER
		do
			sum.set_item (0); count := array.count
			from i := 0 until i = count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
			end
		end

	iterate_from_i_until_i_gt_count (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		local
			i: INTEGER
		do
			sum.set_item (0)
			from i := 1 until i > array.count loop
				sum.set_item (sum.item + array [i])
				i := i + 1
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

	iterate_do_all (array: ARRAYED_LIST [INTEGER]; sum: INTEGER_REF)
		do
			sum.set_item (0)
			array.do_all (agent increment (sum, ?))
		end

feature {NONE} -- Implementation

	increment (a_sum: INTEGER_REF; n: INTEGER)
		do
			a_sum.set_item (a_sum.item + n)
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Compare list iteration methods", 	agent compare_list_iteration_methods]
			>>)
		end

end
