note
	description: "[
		Command line interface to class [$source EL_BENCHMARK_COMMAND_SHELL] which
		contains a menu of benchmarks for various classes.
	]"
	notes: "[
		Command switch: -benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:34:00 GMT (Sunday 4th April 2021)"
	revision: "17"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [BENCHMARK_COMMAND_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (3000)
		end

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("trial_duration", "Routine trial duration in milliseconds")
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Menu driven benchmark tests"

end