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
	date: "2025-04-25 9:55:07 GMT (Friday 25th April 2025)"
	revision: "20"

class
	EL_BENCHMARK_ROUTINE_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ROUTINE]
		rename
			make as make_sized
		end

	EL_MODULE_LIO; EL_MODULE_EXECUTABLE; EL_MODULE_MEMORY

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

	trial_duration: INTEGER
		-- duration of trial in millisecs

feature -- Basic operations

	perform
		-- perform comparisons
		local
			benchmark: EL_BENCHMARK_ROUTINES; l_count: NATURAL_64
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
		end

	print_comparison
		local
		do
			if is_lio_enabled then
				lio.put_new_line
				lio.put_labeled_string ("RESULTS", label)
				lio.put_new_line
				lio.put_substitution ("Passes over %S millisecs (in descending order)", [trial_duration])
				lio.put_new_line_x2
			end
			application_count_list.print_comparison (lio, "%S times (%S)")
		end

feature -- Element change

	set_trial_duration (a_trial_duration: INTEGER)
		do
			trial_duration := a_trial_duration
		end

feature {NONE} -- Internal attributes

	application_count_list: EL_NAMED_BENCHMARK_MAP_LIST
		-- list of number of times that `action' can be applied within the `trial_duration' in milliseconds
		-- in descending order

feature {NONE} -- Constants

	Default_trial_duration: INTEGER
		once
			Result := 500
		end

end