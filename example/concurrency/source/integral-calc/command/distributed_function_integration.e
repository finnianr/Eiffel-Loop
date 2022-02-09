note
	description: "Distributed integration using class [$source EL_FUNCTION_DISTRIBUTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-09 0:02:22 GMT (Wednesday 9th February 2022)"
	revision: "1"

class
	DISTRIBUTED_FUNCTION_INTEGRATION

inherit
	DISTRIBUTED_INTEGRATION_COMMAND [DOUBLE]
		redefine
			distributer
		end

create
	make

feature -- Constants

	Description: STRING = "Distributed integration using class EL_FUNCTION_DISTRIBUTER"

feature {NONE} -- Implementation

	collect_integral (lower, upper: DOUBLE; a_delta_count: INTEGER)
		do
			distributer.wait_apply (agent integral (function, lower, upper, a_delta_count))
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