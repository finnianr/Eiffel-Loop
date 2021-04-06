note
	description: "A table for doing comparitve performance benchmarking of routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-05 16:19:21 GMT (Monday 5th April 2021)"
	revision: "6"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_STRING_HASH_TABLE [ROUTINE, STRING]
		rename
			make as make_table
		end

	EL_BENCHMARK_ROUTINES
		undefine
			is_equal, copy, default_create
		end

	SINGLE_MATH
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

create
	make

feature {NONE} -- Initialization

	make (routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]]; a_trial_duration, a_iteration_count: INTEGER)
		do
			make_table (routines)
			trial_duration := a_trial_duration; iteration_count := a_iteration_count
		end

feature -- Access

	application_count_list: EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [STRING, INTEGER]
		-- list of number of times that `action' can be applied within the `trial_duration' in milliseconds
		-- in descending order
		local
			timer: EL_EXECUTION_TIMER
		do
			create Result.make (count)
			create timer.make
			across Current as routine loop
				if is_lio_enabled then
					lio.put_labeled_string ("Repeating for " + trial_duration.out + " millisecs", routine.key)
					lio.put_new_line
				end
				Result.extend (routine.key, application_count (timer, routine.item, trial_duration, workbench_count))
				Memory.collect
			end
			Result.sort (False)
		end

feature -- Measurement

	iteration_count: INTEGER

	max_key_width: INTEGER
		-- character width of longest key string
		do
			from start until after loop
				if key_for_iteration.count > Result then
					Result := key_for_iteration.count
				end
				forth
			end
		end

	trial_duration: INTEGER

feature -- Basic operations

	print_comparison
		local
			count_list: like application_count_list; s: EL_STRING_8_ROUTINES
			highest_count, description_width: INTEGER
			format: FORMAT_INTEGER
		do
			count_list := application_count_list
			description_width := max_key_width
			highest_count := count_list.first_value
			create format.make (log (highest_count).rounded + 1)

			if is_lio_enabled then
				lio.put_new_line
				lio.put_line ("Routine application counts for trial duration (in descending order)")
			end
			from count_list.start until count_list.after loop
				lio.put_labeled_string (
					count_list.item_key + s.n_character_string (' ', description_width - count_list.item_key.count + 1),
					integer_comparison_string (count_list.item_value, highest_count, "times", format)
				)
				lio.put_new_line
				count_list.forth
			end
		end

feature {NONE} -- Implementation

	workbench_count: INTEGER
		-- `iteration_count' with adjusted for work bench mode
		do
			if Executable.is_work_bench then
				Result := iteration_count // 100
			else
				Result := iteration_count
			end
		end

end