note
	description: "Implementation of ${EL_HASH_SET [HASHABLE]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-13 7:31:35 GMT (Thursday 13th November 2025)"
	revision: "11"

deferred class
	EL_HASH_SET_BASE [H -> HASHABLE]

inherit
	TRAVERSABLE_SUBSET [H]
		rename
			extend as put,
			item as iteration_item,
			remove as remove_item
		end

	FINITE [H]
		undefine
			changeable_comparison_criterion, is_empty
		end

	EL_HASH_SET_CONSTANTS

feature {NONE} -- Initialization

	make_with_key_tester (n: INTEGER; a_key_tester: detachable EQUALITY_TESTER [H])
		-- Allocate hash table for at least `n' items with `a_key_tester' to compare keys.
		-- If `a_key_tester' is void, it uses `~' for comparison.
		-- The table will be resized automatically if more than `n' items are inserted.
		require
			n_non_negative: n >= 0
		local
			p: PRIMES; default_value: detachable H
		do
			key_tester := a_key_tester
			create p
			capacity := p.higher_prime ((3 * n) // 2)
			if capacity < 5 then
				capacity := 5
			end
			create content.make_filled (default_value, capacity)
			create deleted_marks.make_filled (False, capacity)
			count := 0; control := 0; position := 0; position_default_key := -1
			iteration_position := capacity -- satisfies invariant: is_empty implies off
			compare_references
			found_item := default_value
			position_default_key := -1
		ensure
			capacity_big_enough: capacity >= n
			count_set: count = 0
		end

feature -- Measurement

	capacity: INTEGER
		-- Size of the table

	count: INTEGER
		-- Number of items actually inserted in `Current'

feature -- Access

	cursor: INTEGER
		-- Cursor
		do
			Result := iteration_position
		end

	found_item: detachable H
		-- Item found during a search with `has' to reduce the number of
		-- search for clients

	item (key: H): detachable H
		-- Item associated with `key', if present
		-- otherwise default value of type `G'
		do
			if attached content as area then
				set_position (key, area, deleted_marks)
				inspect control
					when Found_constant then
						Result := area [position]
				else
				end
			end
		end

	iteration_item, key_for_iteration: H
		-- Item at cursor position
		do
			check attached content [iteration_position] as l_item then
				Result := l_item
			end
		end

	key_at (n: INTEGER): detachable H
		-- Key corresponding to entry `n'
		do
			if n >= 0 and n < content.count then
				Result := content [n]
			end
		end

	key_tester: detachable EQUALITY_TESTER [H]
		-- Tester used for comparing keys.	

feature -- Status query

	conflict: BOOLEAN
			-- Did last operation insert an item?
		do
			Result := not inserted
		end

	extendible: BOOLEAN = True
		-- May new items be added?

	found: BOOLEAN
		-- Did last operation find the item sought?
		do
			Result := control = Found_constant
		end

	full: BOOLEAN = False

	has (key: H): BOOLEAN
		-- Is `access_key' currently used?
		-- (Shallow equality)
		do
			if count > 0 then
				set_position (key, content, deleted_marks)
				Result := (control = Found_constant)
			end
		end

	has_key (key: H): BOOLEAN
		-- Is `access_key' currently used?
		-- (Shallow equality)
		do
			search (key)
			Result := (control = Found_constant)
		end

	inserted: BOOLEAN
		-- Did last operation insert an item?

	is_empty: BOOLEAN
		-- Is structure empty?
		do
			Result := (count = 0)
		end

	prunable: BOOLEAN = True

	reference_comparison: BOOLEAN
		-- Is current comparing keys using `='.
		do
			Result := not object_comparison
		end

feature {EL_HASH_SET_ITERATION_CURSOR} -- Implementation access

	next_iteration_position (index: INTEGER): INTEGER
		-- Given an iteration position `index', compute the next one
		do
			Result := next_iteration_index (index, capacity - 1, content, deleted_marks)
		end

	next_iteration_index (index, last_index: INTEGER; area: like content; deleted: like deleted_marks): INTEGER
		do
			from Result := index + 1 until Result > last_index or else valid_key (Result, area, deleted) loop
				Result := Result + 1
			end
		end

	set_key_tester (a_key_tester: like key_tester)
		do
			key_tester := a_key_tester
			set_comparison_method
		end

feature {NONE} -- Implementation

	append_to (other: EL_HASH_SET [H])
		local
			index, last_index: INTEGER; break: BOOLEAN
		do
			if attached content as area and then attached deleted_marks as deleted then
				last_index := capacity - 1
				from index := -1 until break loop
					index := next_iteration_index (index, last_index, area, deleted)
					if index > last_index then
						break := True
					else
						other.put (area [index])
					end
				end
			end
		end

	expand_size
		-- Double the capacity of `Current'.
		-- Transfer everything except deleted keys.
		do
			resize ((3 * capacity) // 2)
		end

	deleted_count: INTEGER
		-- count of deleted marks that are `True'
		local
			i: INTEGER
		do
			if attached deleted_marks as marks then
				from i := 1 until i = marks.count loop
					Result := Result + marks [i].to_integer
					i := i + 1
				end
			end
		end

	new_key_tester: like key_tester
		do
		end

	set_comparison_method
		do
			if ({H}).is_expanded then
				comparison_method := Compare_expanded

			elseif attached key_tester then
				comparison_method := Compare_with_test

			elseif object_comparison then
				comparison_method := Compare_is_equal
			else
				comparison_method := Compare_reference
			end
		end

	same_keys (a_search_key, a_key: H): BOOLEAN
		-- Does `a_search_key' equal to `a_key' using `comparison_method'?
		do
			inspect comparison_method
				when Compare_expanded, Compare_reference then
					Result := a_search_key = a_key

				when Compare_is_equal then
					Result := a_search_key ~ a_key

				when Compare_with_test then
					if attached key_tester as l_tester then
						Result := l_tester.test (a_search_key, a_key)
					end
			else
			end
		end

	set_position (search_key: H; area: like content; deleted: like deleted_marks)
			-- Set position of item for `search_key'.
			-- If successful, set `position' to index
			-- of item with this key (the same index as the key's index).
			-- If not, set position to possible position for insertion.
			-- Set `control' to `Found_constant' or `Not_found_constant'.
		local
			increment, hash_code, table_size, index: INTEGER
			first_available_position, visited_count: INTEGER
			old_key, default_key: H; break: BOOLEAN
		do
			control := Not_found_constant
			first_available_position := -1
			table_size := capacity
			hash_code := search_key.hash_code
		-- Increment computed for no cycle: `table_size' is prime
			increment := 1 + hash_code \\ (table_size - 1)
			from
				index := (hash_code \\ table_size) - increment
			until
				break or else visited_count >= table_size
			loop
				index := (index + increment) \\ table_size
				visited_count := visited_count + 1
				old_key := area [index]
				if old_key = default_key or old_key = Void then
					if index = position_default_key then
						control := Found_constant
						break := True
					elseif not deleted [index] then
						control := Not_found_constant
						break := True
						if first_available_position >= 0 then
							index := first_available_position
						end
					elseif first_available_position < 0 then
						first_available_position := index
					end
				elseif same_keys (search_key, old_key) then
					control := Found_constant
					break := True
				end
			end
			if not break and then first_available_position >= 0 then
				index := first_available_position
			end
			position := index
		end

	soon_full: BOOLEAN
		-- Is `Current' close to being filled?
		-- (If so, resizing is needed to avoid performance degradation.)
		do
			Result := (content.count * Size_threshold <= 100 * count)
		end

	valid_key (index: INTEGER; area: like content; deleted: like deleted_marks): BOOLEAN
		require
			valid_index: 0 <= index and index < capacity
		local
			default_key: H
		do
			if not deleted_marks [index] then
				if area [index] = default_key and then index = position_default_key then
					 Result := True
				else
					Result := area [index] /= default_key
				end
			end
		ensure
			definition: Result implies area [index] /= Void
		end

feature {NONE} -- Deferred

	resize (n: INTEGER)
		-- Resize table to accommodate `n' elements.
		require
			n_non_negative: n >= 0
			n_greater_than_count: n >= count
		deferred
		end

	search (key: H)
		-- Search for item of key `key'
		-- If found, set `found' to True, and set
		-- `found_item' to item associated with `key'.
		deferred
		ensure
			item_if_found: found implies (found_item = content [position])
		end

feature {EL_HASH_SET_BASE, EL_HASH_SET_ITERATION_CURSOR} -- Internal attributes access

	content: SPECIAL [detachable H]
		-- Content

	deleted_marks: SPECIAL [BOOLEAN]
		-- deleted marks

feature {NONE} -- Internal attributes

	control: INTEGER
		-- Control code set by operations that may return
		-- several possible conditions.
		-- Possible control codes are the following:

	comparison_method: NATURAL_8

	iteration_position: INTEGER
		-- Iteration position value

	position: INTEGER
		-- Hash table cursor

	position_default_key: INTEGER
		-- position of key that is a default value if keys are expanded types
		-- Useful if we want to use 0 as key for `EL_HASH_SET [INTEGER]'

invariant
	count_big_enough: 0 <= count
	consistent_deletions: capacity - deleted_count = count
	comparison_method_set: comparison_method > 0

end