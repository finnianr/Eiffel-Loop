note
	description: "Command shell specialized for performance comparison benchmarks"
	notes: "[
		BENCHMARKING: HTTP status enumerations

			HTTP_STATUS_ENUM    : 25648.0 bytes (100%)
			HTTP_STATUS_TABLE   : 16848.0 bytes (-34.3%)
			EL_HTTP_STATUS_ENUM :  5376.0 bytes (-79.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 11:03:58 GMT (Friday 25th April 2025)"
	revision: "27"

deferred class
	EL_BENCHMARK_COMMAND_SHELL

inherit
	EL_APPLICATION_COMMAND_SHELL
		rename
			make as make_shell
		redefine
			set_standard_options
		end

	EL_STRING_GENERAL_ROUTINES_I

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

feature -- Status query

	is_performance: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Implementation

	new_benchmarks: TUPLE
		deferred
		end

	new_command_table: like command_table
		local
			factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
			sortable_list: EL_ARRAYED_LIST [EL_BENCHMARK_COMPARISON]
		do
			create factory
			create Result.make (benchmark_types.count)
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
					Result [as_zstring (benchmark.description)] := agent benchmark.execute
				end
			end
		end

	set_standard_options (table: like new_command_table)
		do
			Precursor (table)
			if is_performance then
				table ["Set " + Duration_prompt] := agent set_trial_duration
			end
		end

	set_trial_duration
		do
			trial_duration.set_item (User_input.integer ("Enter " + Duration_prompt))
			lio.put_new_line
		end

feature {NONE} -- Internal attributes

	benchmark_types: EL_TUPLE_TYPE_LIST [EL_BENCHMARK_COMPARISON]

	trial_duration: INTEGER_REF

feature {NONE} -- Constants

	Duration_prompt: STRING = "trial duration in millisecs"

end