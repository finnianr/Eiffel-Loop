note
	description: "Structures whose items may be accessed sequentially, one-way"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-21 9:46:05 GMT (Friday 21st July 2023)"
	revision: "16"

deferred class
	EL_LINEAR [G]

inherit
	LINEAR [G]
		redefine
			do_all, for_all, index_of, there_exists
		end

	EL_CONTAINER_STRUCTURE [G]
		rename
			current_container as current_linear
		undefine
			object_comparison
		end

feature -- Access

	index_for_value (target_value: ANY; value: FUNCTION [G, ANY]): INTEGER
			-- index of item with function returning result equal to value, 0 if not found
		do
			push_cursor
			find_first_equal (target_value, value)
			if found then
				Result := index
			end
			pop_cursor
		end

	index_of (v: like item; i: INTEGER): INTEGER
			-- Index of `i'-th occurrence of item identical to `v'.
			-- (Reference or object equality,
			-- based on `object_comparison'.)
			-- 0 if none.
		do
			push_cursor
			Result := Precursor (v, i)
			pop_cursor
		end

feature -- Status query

	found: BOOLEAN
		do
			Result := not exhausted
		end

	for_all (predicate: FUNCTION [G, BOOLEAN]): BOOLEAN
		-- `True' if all split items match `predicate'
		do
			push_cursor
			Result := True
			from start until not Result or after loop
				Result := predicate (item)
				forth
			end
			pop_cursor
		end

	there_exists (predicate: FUNCTION [G, BOOLEAN]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		do
			push_cursor
			from start until Result or after loop
				Result := predicate (item)
				forth
			end
			pop_cursor
		end

feature -- Basic operations

	do_all (action: PROCEDURE [like item])
		-- apply `action' for all delimited substrings
		do
			push_cursor
			from start until after loop
				action (item)
				forth
			end
			pop_cursor
		end

feature -- Cursor movement

	find_first_differing (chain: CHAIN [G])
		-- find first `item' to differ from corresponding item in `chain'
		local
			differs, equals_comparison: BOOLEAN
		do
			equals_comparison := object_comparison
			from start until after or else differs loop
				if not chain.valid_index (index) then
					differs := True
				elseif equals_comparison then
					differs := item /~ chain [index]
				else
					differs := item /= chain [index]
				end
				if not differs then
					forth
				end
			end
		end

	find_first (condition: EL_QUERY_CONDITION [G])
			-- Find first `item' that meets `condition'
		do
			start; find_next_item (condition)
		end

	find_first_conforming (type: TYPE [G])
		do
			start; find_next_conforming_item (type)
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

	find_next_conforming (type: TYPE [G])
		do
			forth
			if not after then
				find_next_conforming_item (type)
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

	current_linear: like Current
		do
			Result := Current
		end

	find_next_conforming_item (type: TYPE [G])
		local
			type_id, item_type_id: INTEGER; match_found: BOOLEAN
		do
			type_id := type.type_id
			from until match_found or after loop
				item_type_id := {ISE_RUNTIME}.dynamic_type (item)
				if {ISE_RUNTIME}.type_conforms_to (item_type_id, item_type_id) then
					match_found := True
				else
					forth
				end
			end
		end

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