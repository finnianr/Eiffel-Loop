note
	description: "Benchmark comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 10:53:44 GMT (Sunday 13th September 2020)"
	revision: "2"

deferred class
	EL_BENCHMARK_COMPARISON

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_EXECUTABLE

feature {EL_FACTORY_CLIENT} -- Initialization

	make (a_number_of_runs: INTEGER_REF)
		do
			number_of_runs := a_number_of_runs
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
			table.put_comparison (number_of_runs)
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

	number_of_runs: INTEGER_REF
end
