note
	description: "Command line interface to create and execute [$source ZSTRING_BENCHMARK_COMMAND]"
	notes: "[
		**Usage**
		
			-zstring_benchmark [-zstring_codec <codec-name>]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:50:44 GMT (Sunday 23rd January 2022)"
	revision: "16"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [ZSTRING_BENCHMARK_COMMAND]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [UC_UTF8_STRING_BENCHMARK]
		do
			create Result
		end

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("output", "HTML output directory", No_checks),
				optional_argument ("runs", "The number of test runs to average over", No_checks),
				optional_argument ("filter", "Routine filter", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		local
			number_of_runs: INTEGER
		do
			if Executable.is_work_bench then
				number_of_runs := 1
			else
				number_of_runs := 100
			end
			Result := agent {like command}.make ("doc/benchmark", number_of_runs, "")
		end

end