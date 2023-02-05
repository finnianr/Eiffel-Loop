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
	date: "2023-02-05 15:53:03 GMT (Sunday 5th February 2023)"
	revision: "14"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ROUTINE]
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

	make (a_label: like label; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		do
			make_table (routines)
			label := a_label; trial_duration := Default_trial_duration
			create application_count_list.make (count)
		end

feature -- Access

	label: READABLE_STRING_GENERAL

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

	perform
		-- perform comparisons
		local
			benchmark: EL_BENCHMARK_ROUTINES; l_count: DOUBLE
		do
			application_count_list.wipe_out
			across Current as routine loop
				if is_lio_enabled then
					lio.put_labeled_string ("Repeating for " + trial_duration.out + " millisecs", routine.key)
					lio.put_new_line
				end
				l_count := benchmark.application_count (routine.item, trial_duration)
				application_count_list.extend (routine.key, l_count)
			end
			application_count_list.sort (False)
		end

	print_comparison
		local
			description_width: INTEGER; highest_count, relative_difference: DOUBLE
			l_label, formatted_value: STRING; l_double: FORMAT_DOUBLE; s: EL_ZSTRING_ROUTINES
		do
			description_width := max_key_width
			highest_count := application_count_list.first_value
			create l_double.make (log10 (highest_count).rounded + 3, 1)

			lio.put_labeled_string ("Benchmark", label)
			lio.put_new_line

			if is_lio_enabled then
				lio.put_new_line
				lio.put_substitution ("Passes over %S millisecs (in descending order)", [trial_duration])
				lio.put_new_line
			end
			if attached application_count_list as list then
				from list.start until list.after loop
					l_label := list.item_key + s.n_character_string (' ', description_width - list.item_key.count + 1)
					formatted_value := l_double.formatted (list.item_value)
					if list.isfirst then
						lio.put_labeled_string (l_label, formatted_value + " times (100%%)")
					else
						relative_difference := ((highest_count - list.item_value) / highest_count) * 100
						lio.put_labeled_string (
							l_label, Template_relative #$ [formatted_value, Percent.formatted (relative_difference)]
						)
					end
					lio.put_new_line
					list.forth
				end
			end
		end

feature -- Element change

	set_trial_duration (a_trial_duration: INTEGER)
		do
			trial_duration := a_trial_duration
		end

feature {NONE} -- Internal attributes

	application_count_list: EL_VALUE_SORTABLE_ARRAYED_MAP_LIST [ZSTRING, DOUBLE]
		-- list of number of times that `action' can be applied within the `trial_duration' in milliseconds
		-- in descending order

feature {NONE} -- Constants

	Default_trial_duration: INTEGER
		once
			Result := 500
		end

	Percent: FORMAT_DOUBLE
		once
			create Result.make (5, 1)
			Result.no_justify
		end

	Template_relative: ZSTRING
		once
			Result := "%S times (-%S%%)"
		end

end