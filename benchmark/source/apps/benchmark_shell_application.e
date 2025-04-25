note
	description: "Benchmark application for shells conforming to ${EL_BENCHMARK_COMMAND_SHELL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 10:57:16 GMT (Friday 25th April 2025)"
	revision: "1"

class
	BENCHMARK_SHELL_APPLICATION [SHELL -> EL_BENCHMARK_COMMAND_SHELL]

inherit
	EL_COMMAND_SHELL_APPLICATION [SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("trial_duration", "Routine trial duration in milliseconds", No_checks)
			>>
		end

	default_make: PROCEDURE [like shell]
		do
			Result := agent make_benchmark_shell (?, 0)
		end

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	make_benchmark_shell (new_shell: like shell; a_trial_duration: INTEGER)
		do
			new_shell.make (a_trial_duration)
		end

end