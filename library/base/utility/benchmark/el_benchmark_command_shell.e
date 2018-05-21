note
	description: "Perform benchmark comparisons in a command shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 10:01:56 GMT (Saturday 19th May 2018)"
	revision: "6"

deferred class
	EL_BENCHMARK_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make_shell
		redefine
			set_standard_options
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_number_of_runs: like number_of_runs)
		do
			make_shell ("BENCHMARK")
			number_of_runs := a_number_of_runs
		end

feature {NONE} -- Implementation

	set_standard_options (table: like new_command_table)
		do
			Precursor (table)
			table ["Set number of runs to average"] := agent set_number_of_runs
		end

	set_number_of_runs
		do
			number_of_runs := User_input.integer ("Enter number of runs")
			lio.put_new_line
		end

	compare (label: STRING; routines: ARRAY [TUPLE [READABLE_STRING_GENERAL, ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			lio.put_labeled_string ("Benchmark", label)
			lio.put_new_line
			create table.make (routines)
			table.put_comparison (number_of_runs)
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER

end
