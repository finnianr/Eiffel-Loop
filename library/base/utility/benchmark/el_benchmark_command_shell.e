note
	description: "Perform benchmark comparisons in a command shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-15 17:23:12 GMT (Thursday 15th November 2018)"
	revision: "8"

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
			create number_of_runs
			number_of_runs.set_item (a_number_of_runs)
			make_shell ("BENCHMARK")
		end

feature {NONE} -- Implementation

	factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
		deferred
		end

	new_command_table: like command_table
		local
			comparison: EL_BENCHMARK_COMPARISON
		do
			create Result.make_equal (factory.types_indexed_by_name.count)
			across factory.types_indexed_by_name as type loop
				comparison := factory.instance_from_alias (type.key, agent {EL_BENCHMARK_COMPARISON}.make (number_of_runs))
				Result [type.key] := agent comparison.execute
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
