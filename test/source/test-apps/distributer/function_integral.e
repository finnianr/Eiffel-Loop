note
	description: "Function integral"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

class
	FUNCTION_INTEGRAL

inherit
	ROUTINE_INTEGRAL [DOUBLE]
		redefine
			distributer
		end

create
	make

feature {NONE} -- Implementation

	collect_integral (f: FUNCTION [DOUBLE, DOUBLE]; lower, upper: DOUBLE; a_delta_count: INTEGER)
		do
			distributer.wait_apply (agent integral (f, lower, upper, a_delta_count))
			-- collect results
			distributer.collect (result_list)
		end

	collect_final
		do
			distributer.collect_final (result_list)
		end

	result_sum: DOUBLE
		do
			across result_list as a_integral loop
				Result := Result + a_integral.item
			end
		end

feature {NONE} -- Internal attributes

	distributer: EL_FUNCTION_DISTRIBUTER [DOUBLE]

end
