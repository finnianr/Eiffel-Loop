note
	description: "Linear"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 15:05:43 GMT (Monday 5th November 2018)"
	revision: "7"

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

	find_first (condition: EL_QUERY_CONDITION [G])
			-- Find first `item' that meets `condition'
		do
			start; find_next_item (condition)
		end

	find_first_equal (target_value: ANY; value: FUNCTION [G, ANY])
		-- Find first `item' where `value (item).is_equal (target_value)'
		do
			find_first (create {EL_FUNCTION_VALUE_QUERY_CONDITION [G]}.make (target_value, value))
		end

	find_first_true (predicate: PREDICATE [G])
		-- Find first `item' where `predicate (item)' is true
		do
			find_first (create {EL_PREDICATE_QUERY_CONDITION [G]}.make (predicate))
		end

	find_next (condition: EL_QUERY_CONDITION [G])
		-- Find next `item' that meets `condition'
		do
			forth
			if not after then
				find_next_item (condition)
			end
		end

	find_next_equal (target_value: ANY; value: FUNCTION [G, ANY])
			-- Find next `item' where `value (item).is_equal (target_value)'
		require
			function_result_same_type: not off implies target_value.same_type (value.item ([item]))
		do
			find_next (create {EL_FUNCTION_VALUE_QUERY_CONDITION [G]}.make (target_value, value))
		end

	find_next_true (predicate: PREDICATE [G])
		-- Find first `item' where `predicate (item)' is true
		do
			find_next (create {EL_PREDICATE_QUERY_CONDITION [G]}.make (predicate))
		end

feature {NONE} -- Implementation

	find_next_item (condition: EL_QUERY_CONDITION [G])
			-- Find next `item' that meets `condition' including the current `item'
		local
			match_found: BOOLEAN
		do
			from until match_found or after loop
				if condition.met (item) then
					match_found := True
				else
					forth
				end
			end
		end

end
