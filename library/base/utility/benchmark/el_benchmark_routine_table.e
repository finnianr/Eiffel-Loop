note
	description: "A table for doing comparitve performance benchmarking of routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:32:05 GMT (Sunday 4th April 2021)"
	revision: "5"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_STRING_HASH_TABLE [ROUTINE, STRING]

	EL_BENCHMARK_ROUTINES
		undefine
			is_equal, copy, default_create
		end

	SINGLE_MATH
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LIO

create
	make

feature -- Access

	application_count_list (trial_duration: INTEGER): EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [STRING, INTEGER]
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
				Result.extend (routine.key, application_count (timer, routine.item, trial_duration))
				Memory.collect
			end
			Result.sort (False)
		end

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

feature -- Basic operations

	print_comparison (trial_duration: INTEGER)
		local
			count_list: like application_count_list; s: EL_STRING_8_ROUTINES
			highest_count, description_width: INTEGER
			format: FORMAT_INTEGER
		do
			count_list := application_count_list (trial_duration)
			description_width := max_key_width
			highest_count := count_list.first_value
			create format.make (log (highest_count).rounded)

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

end