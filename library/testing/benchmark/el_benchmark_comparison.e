note
	description: "Benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-08 8:52:53 GMT (Tuesday 8th August 2023)"
	revision: "14"

deferred class
	EL_BENCHMARK_COMPARISON

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_trial_duration: INTEGER_REF)
		do
			trial_duration := a_trial_duration
			initialize
		end

feature -- Access

	description: READABLE_STRING_GENERAL
		deferred
		end

feature -- Basic operations

	execute
		deferred
		end

feature {NONE} -- Implementation

	compare (label: READABLE_STRING_GENERAL; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			create table.make (label, routines)
			if trial_duration.item.to_boolean then
				table.set_trial_duration (trial_duration.item)
			end
			lio.put_new_line
			lio.put_labeled_string ("Class", generator)
			lio.put_new_line_x2
			lio.put_labeled_string ("BENCHMARKING", table.label)
			lio.put_new_line_x2

			table.perform
			table.print_comparison
			lio.put_new_line
		end

	initialize
		do
			do_nothing
		end

feature {NONE} -- Internal attributes

	trial_duration: INTEGER_REF

end