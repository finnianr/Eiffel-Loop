note
	description: "Test for [$source EL_BENCHMARK_COMMAND_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 9:53:48 GMT (Friday 18th May 2018)"
	revision: "7"

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
			Result := agent {like command}.make (500)
		end

feature {NONE} -- Constants

	Option_name: STRING = "benchmark"

	Description: STRING = "Menu driven benchmark tests"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{BENCHMARK_APP}, All_routines]
			>>
		end
end
