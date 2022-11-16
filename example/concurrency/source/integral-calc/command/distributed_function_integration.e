note
	description: "Distributed integration using class [$source EL_FUNCTION_DISTRIBUTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	DISTRIBUTED_FUNCTION_INTEGRATION

inherit
	DISTRIBUTED_INTEGRATION_COMMAND [DOUBLE]

create
	make

feature {NONE} -- Implementation

	add_to_sum
		do
			distributer.do_with_completed (agent add_partial_to_sum)
		end

	add_partial_to_sum (partial_integral: DOUBLE)
		do
			integral_sum := integral_sum + partial_integral
			addition_count := addition_count + 1
		end

	calculate_bound (bound: like split_bounds.item; a_delta_count: INTEGER)
		do
			distributer.wait_apply (agent integral (function, bound.lower_, bound.upper_, a_delta_count))
		end

	new_distributer (cpu_percent: INTEGER): EL_FUNCTION_DISTRIBUTER [DOUBLE]
		do
			create Result.make (cpu_percent)
		end

end