note
	description: "Procedure integral"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:27:50 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	PROCEDURE_INTEGRAL

inherit
	ROUTINE_INTEGRAL [INTEGRAL_MATH]
		redefine
			distributer
		end

create
	make

feature {NONE} -- Implementation

	collect_integral (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE; a_delta_count: INTEGER)
		local
			integral_math: INTEGRAL_MATH
		do
			create integral_math.make (f, lower, upper, a_delta_count)
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
