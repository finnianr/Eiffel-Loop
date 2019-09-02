note
	description: "Sub-application for [$source EL_BENCHMARK_COMMAND_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 12:00:56 GMT (Monday 2nd September 2019)"
	revision: "12"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [BENCHMARK_COMMAND_SHELL]
		redefine
			argument_specs, default_make, initialize
		end

feature {NONE} -- Implementation

	initialize
		do
			Precursor
			Console.show ({EL_BENCHMARK_ROUTINE_TABLE})
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("runs", "Number of runs to average over")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (500)
		end

feature {NONE} -- Constants

	Description: STRING = "Menu driven benchmark tests"


end
