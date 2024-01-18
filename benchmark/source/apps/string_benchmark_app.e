note
	description: "[
		Command line interface to class ${STRING_BENCHMARK_SHELL} which
		contains a menu of benchmarks for various classes.
	]"
	notes: "[
		Command switch: -string_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-13 16:07:45 GMT (Monday 13th March 2023)"
	revision: "24"

class
	STRING_BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [STRING_BENCHMARK_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (0)
		end

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("trial_duration", "Routine trial duration in milliseconds", No_checks)
			>>
		end

end