note
	description: "Summary description for {EL_LINEAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "3"

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
			match_found: BOOLEAN; item_arg: TUPLE [G]
		do
			create item_arg
			from until match_found or after loop
				item_arg.put (item, 1)
				if value ~ value_function.item (item_arg) then
					match_found := True
				else
					forth
				end
			end
		end

end
