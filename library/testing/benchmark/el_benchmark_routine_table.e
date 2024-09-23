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
	date: "2024-09-22 17:48:22 GMT (Sunday 22nd September 2024)"
	revision: "19"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ROUTINE]
		rename
			make as make_sized
		end

	DOUBLE_MATH
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_LIO; EL_MODULE_EXECUTABLE; EL_MODULE_MEMORY

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make (a_label: like label; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		do
			make_assignments (routines)
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
			application_count_list.sort_by_value (False)
		end

	print_comparison
		local
			description_width: INTEGER; highest_count, relative_difference: DOUBLE
			l_label, formatted_value, relative_percentile: STRING; l_double: FORMAT_DOUBLE
		do
			description_width := max_key_width
			highest_count := application_count_list.first_value
			create l_double.make (log10 (highest_count).rounded + 3, 1)

			if is_lio_enabled then
				lio.put_new_line
				lio.put_labeled_string ("RESULTS", label)
				lio.put_new_line
				lio.put_substitution ("Passes over %S millisecs (in descending order)", [trial_duration])
				lio.put_new_line_x2
			end
			if attached application_count_list as list then
				from list.start until list.after loop
					l_label := list.item_key + space * (description_width - list.item_key.count + 1)
					formatted_value := l_double.formatted (list.item_value)
					if list.isfirst then
						lio.put_labeled_string (l_label, formatted_value + " times (100%%)")
					else
						relative_difference := ((highest_count - list.item_value) / highest_count) * 100
						relative_percentile := Format.double_as_string (relative_difference, once "999.9%%")
						lio.put_labeled_string (l_label, Template_relative #$ [formatted_value, relative_percentile])
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

	application_count_list: EL_ARRAYED_MAP_LIST [ZSTRING, DOUBLE]
		-- list of number of times that `action' can be applied within the `trial_duration' in milliseconds
		-- in descending order

feature {NONE} -- Constants

	Default_trial_duration: INTEGER
		once
			Result := 500
		end

	Template_relative: ZSTRING
		once
			Result := "%S times (-%S)"
		end

end