note
	description: "Distributed integration using class [$source EL_PROCEDURE_DISTRIBUTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	DISTRIBUTED_PROCEDURE_INTEGRATION

inherit
	DISTRIBUTED_INTEGRATION_COMMAND [INTEGRAL_MATH]

create
	make

feature {NONE} -- Implementation

	add_to_sum
		do
			distributer.do_with_completed (agent add_partial_to_sum)
		end

	add_partial_to_sum (math: INTEGRAL_MATH)
		do
			integral_sum := integral_sum + math.integral
			addition_count := addition_count + 1
		end

	calculate_bound (bound: like split_bounds.item; a_delta_count: INTEGER)
		local
			integral_math: INTEGRAL_MATH
		do
			create integral_math.make (function, bound.lower_, bound.upper_, a_delta_count)
			distributer.wait_apply (agent integral_math.calculate)
		end

	new_distributer (cpu_percent: INTEGER): EL_PROCEDURE_DISTRIBUTER [INTEGRAL_MATH]
		do
			create Result.make (cpu_percent)
		end

end