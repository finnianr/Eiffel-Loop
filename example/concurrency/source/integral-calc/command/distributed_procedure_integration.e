note
	description: "Distributed integration using class [$source EL_PROCEDURE_DISTRIBUTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 0:02:32 GMT (Wednesday 9th February 2022)"
	revision: "1"

class
	DISTRIBUTED_PROCEDURE_INTEGRATION

inherit
	DISTRIBUTED_INTEGRATION_COMMAND [INTEGRAL_MATH]
		redefine
			distributer
		end

create
	make

feature -- Constants

	Description: STRING = "Distributed integration using class EL_PROCEDURE_DISTRIBUTER"

feature {NONE} -- Implementation

	collect_integral (lower, upper: DOUBLE; a_delta_count: INTEGER)
		local
			integral_math: INTEGRAL_MATH
		do
			create integral_math.make (function, lower, upper, a_delta_count)
			distributer.wait_apply (agent integral_math.calculate)

			-- collect results
			distributer.collect (result_list)
		end

	collect_final
		do
			distributer.collect_final (result_list)
		end

	result_sum: DOUBLE
		do
			across result_list as value loop
				Result := Result + value.item.integral
			end
		end

feature {NONE} -- Internal attributes

	distributer: EL_PROCEDURE_DISTRIBUTER [INTEGRAL_MATH]

end