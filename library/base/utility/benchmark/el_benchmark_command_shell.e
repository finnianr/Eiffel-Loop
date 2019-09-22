note
	description: "Command shell specialized for performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-19 9:32:03 GMT (Thursday   19th   September   2019)"
	revision: "10"

deferred class
	EL_BENCHMARK_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_COMMAND
		export
			{ANY} make_shell
		redefine
			set_standard_options
		end

	EL_FACTORY_CLIENT

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_number_of_runs: INTEGER)
		do
			number_of_runs := a_number_of_runs
			make_shell ("BENCHMARK")
		end

feature {NONE} -- Implementation

	do_comparison (name: ZSTRING)
		local
			comparison: EL_BENCHMARK_COMPARISON
		do
			comparison := factory.instance_from_alias (name, agent {EL_BENCHMARK_COMPARISON}.make (number_of_runs))
			comparison.execute
		end

	factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
		deferred
		end

	new_command_table: like command_table
		do
			create Result.make_equal (Factory.count)
			across Factory.alias_names as name loop
				Result [name.item] := agent do_comparison (name.item)
			end
		end

	set_number_of_runs
		do
			number_of_runs.set_item (User_input.integer ("Enter number of runs"))
			lio.put_new_line
		end

	set_standard_options (table: like new_command_table)
		do
			Precursor (table)
			table ["Set number of runs to average"] := agent set_number_of_runs
		end

feature {NONE} -- Internal attributes

	number_of_runs: INTEGER_REF

end
