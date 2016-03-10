note
	description: "Summary description for {EL_LINEAR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_LINEAR [G]

inherit
	LINEAR [G]

feature -- Status setting

	start_find
		do
			before_find := True
		end

feature -- Status query

	before_find: BOOLEAN
		-- True if starting a new find

feature -- Basic operations

	find_first (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
		do
			start_find; find_next (value, value_function)
		end

	find_next (value: ANY; value_function: FUNCTION [G, TUPLE, ANY])
			-- Find next item where function returns a value matching 'a_value'
		require
			valid_open_count: value_function.open_count = 1
			valid_value_function: not off implies value_function.empty_operands.valid_type_for_index (item, 1)
			function_result_same_type: not off implies value.same_type (value_function.item ([item]))
		local
			found: BOOLEAN
		do
			if before_find then
				start; before_find := False
			else
				forth
			end
			from until found or after loop
				found := value ~ value_function.item ([item])
				if not found then
					forth
				end
			end
		end

end
