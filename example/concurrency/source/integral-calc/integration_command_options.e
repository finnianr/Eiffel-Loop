note
	description: "Test work distributer command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 23:36:26 GMT (Tuesday 8th February 2022)"
	revision: "6"

class
	INTEGRATION_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			Help_text, initialize_fields
		end

create
	make, make_default

feature {NONE} -- Initialization

	initialize_fields
		do
			delta_count := 10000
			repetition_count := 1
			task_count := 4
			term_count := 4
			thread_count := 4
			create multiplicands.make_from_array (<< 1.0 >>)
			integral_range := [0.0, 2.0]
			command_type := "single_thread"
		end

feature -- Access

	command_type: STRING
		-- command alias

	delta_count: INTEGER

	repetition_count: INTEGER

	task_count: INTEGER

	term_count: INTEGER

	multiplicands: ARRAYED_LIST [DOUBLE]

	integral_range: TUPLE [radians_lower, radians_upper: DOUBLE]

	thread_count: INTEGER

	max_priority: BOOLEAN

	priority_name: STRING
		do
			if max_priority then
				Result := "maximum"
			else
				Result := "normal"
			end
		end

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				command_type:
					Type of integral calculation command to use
					Valid values:
						single_thread; distributed_function; distributed_procedure
				delta_count:
					Number of integral range "split intervals" to calculate
				integral_range:
					Range lower to upper expressed as multiples of PI
				max_priority:
					Use maximum priority threads
				repetition_count:
					Number of repetitions of each calculation to do
				multiplicands:
					Multiplicands for `x' in complex sine function
				task_count:
					Number of discreet tasks to divide integral calculation into for thread assignation
				term_count:
					Number of sine functions to add together for test function
				thread_count:
					Number of threads to use to calculate integral of test sine function
			]")
		end

end