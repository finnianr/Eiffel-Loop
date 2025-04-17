note
	description: "[
		Benchmark shell menu ${STRING_BENCHMARK_SHELL} for string related performance tests
	]"
	notes: "[
		Usage:
			el_benchmark -string_benchmark
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 9:14:02 GMT (Thursday 17th April 2025)"
	revision: "28"

class
	STRING_BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_APPLICATION [STRING_BENCHMARK_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE [like shell]
		do
			Result := agent {like shell}.make (0)
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