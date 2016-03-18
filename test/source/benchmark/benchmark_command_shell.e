note
	description: "Summary description for {EL_BENCHMARK_COMMAND_SHELL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-18 12:54:22 GMT (Friday 18th March 2016)"
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
			i: INTEGER
		do
			log.enter ("compare_list_iteration_methods")
			create array.make_filled (10000)
			create actions.make (<<
				["from_i_until_i_gt_count", 	agent iterate_from_i_until_i_gt_count (array)],
				["start_after_forth", 			agent iterate_start_after_forth (array)],
				["across_array_as_n", 			agent iterate_across_array_as_n (array)]
			>>)
			compare_benchmarks (actions)
			log.exit
		end

feature {NONE} -- Iteration variations

	iterate_across_array_as_n (array: ARRAYED_LIST [INTEGER])
		local
			n: INTEGER
		do
			across array as number loop
				n := number.item
			end
		end

	iterate_from_i_until_i_gt_count (array: ARRAYED_LIST [INTEGER])
		local
			i, n: INTEGER
		do
			from i := 1 until i > array.count loop
				n := array [i]
				i := i + 1
			end
		end

	iterate_start_after_forth (array: ARRAYED_LIST [INTEGER])
		local
			n: INTEGER
		do
			from array.start until array.after loop
				n := array.item
				array.forth
			end
		end

feature {NONE} -- Factory

	new_command_table: like command_table
		do
			create Result.make (<<
				["Compare list iteration methods", 	agent compare_list_iteration_methods]
			>>)
		end

end
