note
	description: "Perform benchmark comparisons in a command shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-18 9:35:51 GMT (Friday 18th May 2018)"
	revision: "5"

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
			table ["Set number or runs to average"] := agent set_number_of_runs
		end

	set_number_of_runs
		do
			number_of_runs := User_input.integer ("Enter number of runs")
			lio.put_new_line
		end

	compare (label: STRING; routines: ARRAY [TUPLE [key: READABLE_STRING_GENERAL; value: ROUTINE]])
		local
			table: EL_BENCHMARK_ROUTINE_TABLE
		do
			lio.put_labeled_string ("Benchmark", label)
			lio.put_new_line
			create table.make (routines)
			table.put_comparison (lio, number_of_runs)
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER

end
