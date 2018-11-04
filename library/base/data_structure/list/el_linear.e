note
	description: "Linear"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "6"

deferred class
	EL_LINEAR [G]

inherit
	LINEAR [G]

feature -- Status query

	found: BOOLEAN
		do
			Result := not exhausted
		end

feature -- Cursor movement

	find_first (value: ANY; value_function: FUNCTION [G, ANY])
		do
			start; find_next_function_value (value, value_function)
		end

	find_next (value: ANY; value_function: FUNCTION [G, ANY])
		do
			forth
			if not after then
				find_next_function_value (value, value_function)
			end
		end

feature {NONE} -- Implementation

	find_next_function_value (value: ANY; value_function: FUNCTION [G, ANY])
			-- Find next item where function returns a value matching 'a_value'
		require
			function_result_same_type: not off implies value.same_type (value_function.item ([item]))
		local
			match_found: BOOLEAN; operands: TUPLE [G]
		do
			create operands
			value_function.set_operands (operands)
			from until match_found or after loop
				operands.put (item, 1); value_function.apply
				if value ~ value_function.last_result then
					match_found := True
				else
					forth
				end
			end
		end

end
