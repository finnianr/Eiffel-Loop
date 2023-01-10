note
	description: "Abstraction to perform integral calculations on a function"
	descendants: "[
			INTEGRATION_COMMAND*
				[$source SINGLE_THREAD_INTEGRATION]
				[$source DISTRIBUTED_INTEGRATION_COMMAND]* [G]
					[$source DISTRIBUTED_FUNCTION_INTEGRATION]
					[$source DISTRIBUTED_PROCEDURE_INTEGRATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-10 10:47:22 GMT (Tuesday 10th January 2023)"
	revision: "4"

deferred class
	INTEGRATION_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_LOG

	EL_DOUBLE_MATH
		rename
			log as natural_log
		export
			{NONE} all
		end

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_option: like option; a_function: like function)
		do
			option := a_option; function := a_function
		end

feature -- Basic operations

	execute
		local
			answer, lower, upper: DOUBLE
		do
			log.enter ("execute")
			lio.put_labeled_string ("Method", description)
			lio.put_new_line
			lio.put_integer_field ("Delta count", option.delta_count)
			lio.put_new_line
			lio.set_timer
			lower := option.integral_range.radians_lower * PI
			upper := option.integral_range.radians_upper * PI
			lio.put_line (Calculating_integral #$ [lower, upper])
			calculate (lower, upper)
			if not is_canceled then
				lio.put_double_field ("integral is", integral_sum)
				lio.put_new_line
				lio.put_elapsed_time
				lio.put_new_line
			end
			log.exit
		end

feature {NONE} -- Implementation

	calculate (lower, upper: DOUBLE)
		deferred
		end

	is_canceled: BOOLEAN
		do
		end

feature {NONE} -- Internal attributes

	function: FUNCTION [DOUBLE, DOUBLE]
		-- function to be integrated

	option: INTEGRATION_COMMAND_OPTIONS

	integral_sum: DOUBLE

feature {NONE} -- Constants

	Calculating_integral: ZSTRING
		once
			Result := "Calculating integral for X = (%S * PI) to (%S * PI)"
		end

end