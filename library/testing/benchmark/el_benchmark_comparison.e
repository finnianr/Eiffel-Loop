note
	description: "Benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-24 4:35:04 GMT (Monday 24th October 2022)"
	revision: "8"

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
		end

feature -- Basic operations

	execute
		deferred
		end

feature {NONE} -- Implementation

	compare (label: STRING; routines: ARRAY [TUPLE [STRING, ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			lio.put_labeled_string ("Benchmark", label)
			lio.put_new_line
			create table.make (routines, trial_duration)
			table.print_comparison
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	trial_duration: INTEGER_REF
end