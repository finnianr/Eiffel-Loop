note
	description: "Command line interface to create and execute ${ZSTRING_BENCHMARK_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "23"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_COMMAND_LINE_APPLICATION [ZSTRING_BENCHMARK_COMMAND]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("output", "HTML output directory", No_checks),
				optional_argument ("template", "HTML page Evolicity template", << file_must_exist >>),
				optional_argument ("duration", "The duration of each in milliseconds", No_checks),
				optional_argument ("filter", "Routine filter with leading or trailing wildcards", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("doc/benchmark", "doc/ZSTRING-benchmarks.evol", 500, "")
		end

end