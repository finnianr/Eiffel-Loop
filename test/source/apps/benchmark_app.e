note
	description: "Summary description for {BENCHMARK_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:25:13 GMT (Monday 29th May 2017)"
	revision: "3"

class
	BENCHMARK_APP

inherit
	EL_COMMAND_SHELL_SUB_APPLICATTION [BENCHMARK_COMMAND_SHELL]
		redefine
			Option_name, default_operands, argument_specs
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [number_of_runs: INTEGER]
		do
			create Result
			Result.number_of_runs := 1
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				optional_argument ("runs", "Number of runs to average over")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "benchmark"

	Description: STRING = "Menu driven benchmark tests"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{BENCHMARK_APP}, "*"]
			>>
		end
end
