note
	description: "A table for doing comparitive performance benchmarking of routines"
	notes: "[
		An array of routines are repeatedly applied for a fixed duration of time in millisecs.
		The number of routine applications (passes) are averaged over the time and a proportion
		number of passes is calculated. Results are listed in descending order of application count (passes)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_STRING_HASH_TABLE [ROUTINE, STRING]
		rename
			make as make_table
		end

	DOUBLE_MATH
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

	EL_MODULE_MEMORY

create
	make

feature {NONE} -- Initialization

	make (routines: ARRAY [TUPLE [STRING, ROUTINE]]; a_trial_duration: INTEGER)
		do
			make_table (routines)
			trial_duration := a_trial_duration
		end

feature -- Access

	application_count_list: EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [STRING, DOUBLE]
		-- list of number of times that `action' can be applied within the `trial_duration' in milliseconds
		-- in descending order
		local
			benchmark: EL_BENCHMARK_ROUTINES
		do
			create Result.make (count)
			across Current as routine loop
				if is_lio_enabled then
					lio.put_labeled_string ("Repeating for " + trial_duration.out + " millisecs", routine.key)
					lio.put_new_line
				end

				Result.extend (routine.key, benchmark.repetition_count (routine.item, trial_duration))
			end
			Result.sort (False)
		end

feature -- Measurement

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
		-- duration of trial in millisecs

feature -- Basic operations

	print_comparison
		local
			count_list: like application_count_list; s: EL_STRING_8_ROUTINES
			description_width: INTEGER; highest_count, relative_difference: DOUBLE; label, formatted_value: STRING
			l_double: FORMAT_DOUBLE
		do
			count_list := application_count_list
			description_width := max_key_width
			highest_count := count_list.first_value
			create l_double.make (log10 (highest_count).rounded + 3, 1)

			if is_lio_enabled then
				lio.put_new_line
				lio.put_substitution ("Passes over %S millisecs (in descending order)", [trial_duration])
				lio.put_new_line
			end
			from count_list.start until count_list.after loop
				label := count_list.item_key + s.n_character_string (' ', description_width - count_list.item_key.count + 1)
				formatted_value := l_double.formatted (count_list.item_value)
				if count_list.isfirst then
					lio.put_labeled_string (label, formatted_value + " times (100%%)")
				else
					relative_difference := ((highest_count - count_list.item_value) / highest_count) * 100
					lio.put_labeled_string (label, Template_relative #$ [formatted_value, Percent.formatted (relative_difference)])
				end
				lio.put_new_line
				count_list.forth
			end
		end

feature {NONE} -- Constants

	Template_relative: ZSTRING
		once
			Result := "%S times (-%S%%)"
		end

	Percent: FORMAT_DOUBLE
		once
			create Result.make (5, 1)
			Result.no_justify
		end

end