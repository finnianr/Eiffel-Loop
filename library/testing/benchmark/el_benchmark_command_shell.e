note
	description: "Command shell specialized for performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-22 16:01:59 GMT (Wednesday 22nd February 2023)"
	revision: "22"

deferred class
	EL_BENCHMARK_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		redefine
			set_standard_options
		end

	EL_FACTORY_CLIENT

	EL_MODULE_USER_INPUT

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_trial_duration: INTEGER)
		do
			trial_duration := a_trial_duration.to_reference
			create benchmark_types.make_from_tuple (new_benchmarks)
			if not benchmark_types.all_conform then
				benchmark_types.log_error (lio, "Invalid benchmark class")
			end
			make_shell ("BENCHMARK COMPARISONS", 20)
		end

feature {NONE} -- Implementation

	new_benchmarks: TUPLE
		deferred
		end

	new_command_table: like command_table
		local
			factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
			sortable_list: EL_ARRAYED_LIST [EL_BENCHMARK_COMPARISON]
			s: EL_ZSTRING_ROUTINES
		do
			create factory
			create Result.make_equal (benchmark_types.count)
			create sortable_list.make (benchmark_types.count)
			across benchmark_types as type loop
				if attached factory.new_item_from_type (type.item) as benchmark then
					benchmark.make (trial_duration)
					sortable_list.extend (benchmark)
				end
			end
			sortable_list.order_by (agent {EL_BENCHMARK_COMPARISON}.description, True)
			across sortable_list as list loop
				if attached list.item as benchmark then
					Result [s.as_zstring (benchmark.description)] := agent benchmark.execute
				end
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

	benchmark_types: EL_TUPLE_TYPE_LIST [EL_BENCHMARK_COMPARISON]

feature {NONE} -- Constants

	Duration_prompt: STRING = "trial duration in millisecs"

end