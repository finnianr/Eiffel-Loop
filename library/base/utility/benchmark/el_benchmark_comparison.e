note
	description: "Benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:10:20 GMT (Sunday 4th April 2021)"
	revision: "3"

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

	compare (label: STRING; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			lio.put_labeled_string ("Benchmark", label)
			lio.put_new_line
			create table.make (routines)
			table.print_comparison (trial_duration)
			lio.put_new_line
		end

	new_iteration_count (finalized_count: INTEGER): INTEGER
		-- iteration count with adjustment for work bench mode
		do
			if Executable.is_work_bench then
				Result := finalized_count // 100
			else
				Result := finalized_count
			end
		end

feature {NONE} -- Internal attributes

	trial_duration: INTEGER_REF
end