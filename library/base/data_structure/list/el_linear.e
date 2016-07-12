note
	description: "Summary description for {EL_LINEAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-16 18:56:49 GMT (Monday 16th March 2015)"
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

feature -- Basic operations

	find_first (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
		do
			start; find_next_function_value (value, value_function)
		end

	find_next (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
		do
			forth
			if not after then
				find_next_function_value (value, value_function)
			end
		end

feature {NONE} -- Implementation

	find_next_function_value (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
			-- Find next item where function returns a value matching 'a_value'
		require
			valid_open_count: value_function.open_count = 1
			valid_value_function: not off implies value_function.empty_operands.valid_type_for_index (item, 1)
			function_result_same_type: not off implies value.same_type (value_function.item ([item]))
		local
			l_tuple: TUPLE [like item] -- Save on garbage collection for long lists
			match_found: BOOLEAN
		do
			create l_tuple
			from until match_found or after loop
				l_tuple.put (item, 1)
				if value ~ value_function.item (l_tuple) then
					match_found := True
				else
					forth
				end
			end
		end

end
