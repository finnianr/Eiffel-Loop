note
	description: "Sub-application for [$source EL_BENCHMARK_COMMAND_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:24:36 GMT (Wednesday 25th September 2019)"
	revision: "15"

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
			Result := agent {like command}.make (10)
		end

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("runs", "Number of runs to average over")
			>>
		end

feature {NONE} -- Constants

	Description: STRING = "Menu driven benchmark tests"

end
