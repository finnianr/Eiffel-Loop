note
	description: "Command shell specialized for performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:11:04 GMT (Sunday 4th April 2021)"
	revision: "14"

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

	make (a_trial_duration: INTEGER)
		do
			trial_duration := a_trial_duration
			make_shell ("BENCHMARK", 10)
		end

feature {NONE} -- Implementation

	do_comparison (name: ZSTRING)
		do
			if attached factory.new_item_from_alias (name) as comparison then
				comparison.make (trial_duration)
				comparison.execute
			end
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

	set_standard_options (table: like new_command_table)
		do
			Precursor (table)
			table ["Set " + Duration_prompt] := agent set_trial_duration
		end

	set_trial_duration
		do
			trial_duration.set_item (User_input.integer ("Enter " + Duration_prompt))
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	trial_duration: INTEGER_REF

feature {NONE} -- Constants

	Duration_prompt: STRING = "trial duration in millisecs"

end