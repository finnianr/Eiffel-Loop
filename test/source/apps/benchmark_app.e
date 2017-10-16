note
	description: "Summary description for {BENCHMARK_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-16 10:38:33 GMT (Monday 16th October 2017)"
	revision: "6"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATION [BENCHMARK_COMMAND_SHELL]
		redefine
			Option_name, argument_specs, default_make
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("runs", "Number of runs to average over")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make (1)
		end

feature {NONE} -- Constants

	Option_name: STRING = "benchmark"

	Description: STRING = "Menu driven benchmark tests"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{BENCHMARK_APP}, "*"]
			>>
		end
end
