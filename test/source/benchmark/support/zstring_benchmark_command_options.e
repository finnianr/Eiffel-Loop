note
	description: "Zstring benchmark command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 13:47:03 GMT (Thursday 14th May 2020)"
	revision: "4"

class
	ZSTRING_BENCHMARK_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS
		redefine
			initialize_fields
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make, make_default

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			if Execution_environment.is_work_bench_mode then
				runs := 1
			else
				runs := 100
			end
		end

feature -- Options

	filter: ZSTRING

	runs: INTEGER

feature -- Access

	number_of_runs: INTEGER
		do
			if Execution_environment.is_work_bench_mode then
				Result := 1
			else
				Result := runs
			end
		end

	routine_filter: like filter
		do
			Result := filter
		end

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := "[
				runs:
					Set number of runs to average over
				filter:
					Routine filter
			]"
		end
end
