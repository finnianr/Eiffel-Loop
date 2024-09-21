note
	description: "Implementation of ${EL_HASH_SET [HASHABLE]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-21 15:28:07 GMT (Saturday 21st September 2024)"
	revision: "1"

deferred class
	EL_HASH_SET_IMPLEMENTATION [H -> HASHABLE]

inherit
	TRAVERSABLE_SUBSET [detachable H]
		rename
			extend as put,
			item as iteration_item,
			remove as remove_item
		undefine
			is_equal, copy, default_create
		redefine
			copy, is_equal
		end

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
			create insertion_marks.make_filled (False, capacity)
			count := 0; control := 0; position := 0; iteration_position := 0
			compare_references
			found_item := default_value
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
			internal_search (key)
			if control = Found_constant then
				Result := content.item (position)
			end
		end

	iteration_item, key_for_iteration: H
		-- Item at cursor position
		do
			check attached content.item (iteration_position) as l_item then
				Result := l_item
			end
		end

	key_at (n: INTEGER): detachable H
		-- Key corresponding to entry `n'
		do
			if n >= 0 and n < content.count then
				Result := content.item (n)
			end
		end

	key_tester: detachable EQUALITY_TESTER [H]
		-- Tester used for comparing keys.	

feature -- Status query

	Extendible: BOOLEAN = True
		-- May new items be added?

	Prunable: BOOLEAN = True

	found: BOOLEAN
		-- Did last operation find the item sought?
		do
			Result := (control = Found_constant)
		end

	has (key: H): BOOLEAN
		-- Is `access_key' currently used?
		-- (Shallow equality)
		do
			if count > 0 then
				internal_search (key)
				Result := (control = Found_constant)
			end
		end

	inserted: BOOLEAN
		-- Did last operation insert an item?

	is_empty: BOOLEAN
		-- Is structure empty?
		do
			Result := (count = 0)
		end

	reference_comparison: BOOLEAN
		-- Is current comparing keys using `='.
		do
			Result := not object_comparison
		end

feature -- Comparison

	same_keys (a_search_key, a_key: H): BOOLEAN
		-- Does `a_search_key' equal to `a_key'?
		--| Default implementation is using ~.
		do
			if attached key_tester as l_tester then
				Result := l_tester.test (a_search_key, a_key)

			elseif object_comparison then
				Result := a_search_key ~ a_key
			else
				Result := a_search_key = a_key
			end
		end

feature -- Duplication

	copy (other: like Current)
		-- Re-initialize from `other'.
		do
			standard_copy (other)
			content := other.content.twin
			insertion_marks := other.insertion_marks.twin
		end

feature -- Contract Support

	valid_cursor (pos: like cursor): BOOLEAN
		-- Can cursor be moved to position `pos'?
		do
			if pos >= capacity or else (pos >= 0 and pos <= capacity) then
				Result := insertion_marks [pos]
			end
		end

feature {EL_HASH_SET_ITERATION_CURSOR} -- Implementation access

	next_iteration_position (a_position: INTEGER): INTEGER
		-- Given an iteration position `a_position', compute the next one
		do
			Result := next_iteration_position_with (a_position, capacity - 1, content, insertion_marks)
		end

	next_iteration_position_with (
		a_position, last_index: INTEGER; area: like content; a_inserted: like insertion_marks
	): INTEGER
		do
			from Result := a_position + 1 until Result > last_index or else a_inserted [Result] loop
				Result := Result + 1
			end
		end

	set_key_tester (a_key_tester: like key_tester)
		do
			key_tester := a_key_tester
		end

feature {NONE} -- Implementation

	add_space
		-- Double the capacity of `Current'.
		-- Transfer everything except deleted keys.
		do
			resize ((3 * capacity) // 2)
		end

	append_to (other: EL_HASH_SET [H])
		local
			pos, last_index: INTEGER; break: BOOLEAN
		do
			if attached content as area and then attached insertion_marks as l_inserted then
				last_index := capacity - 1
				from pos := -1 until break loop
					pos := next_iteration_position_with (pos, last_index, area, l_inserted)
					if pos > last_index then
						break := True
					else
						other.put (area [pos])
					end
				end
			end
		end

	insertion_count: INTEGER
		-- count of insertion marks that are `True'
		local
			i: INTEGER
		do
			if attached insertion_marks as marks then
				from i := 1 until i = marks.count loop
					Result := Result + marks [i].to_integer
					i := i + 1
				end
			end
		end

	internal_search (search_key: H)
		-- Search for item of `search_key'.
		-- If successful, set `position' to index
		-- of item with this key (the same index as the key's index).
		-- If not, set position to possible position for insertion.
		-- Set `control' to `Found_constant' or `Not_found_constant'.
		local
			increment, hash_code, table_size, pos: INTEGER
			first_available_position, visited_count: INTEGER
			old_key, default_key: detachable H; break: BOOLEAN
		do
			-- Per precondition
			check search_key_not_void: search_key /= Void end
			if attached insertion_marks as l_inserted and then attached content as area then
				from
					first_available_position := -1
					table_size := capacity
					hash_code := search_key.hash_code
				-- Increment computed for no cycle: `table_size' is prime
					increment := 1 + hash_code \\ (table_size - 1)
					pos := (hash_code \\ table_size) - increment
				until
					break or else visited_count >= table_size
				loop
					pos := (pos + increment) \\ table_size
					visited_count := visited_count + 1
					if l_inserted [pos] then
						old_key := area.item (pos)
						if object_comparison then
							if same_keys (search_key, old_key) then
								control := Found_constant; break := True
							end
						elseif search_key = old_key then
							control := Found_constant; break := True
						end
					else
						control := Not_found_constant
						if first_available_position < 0 then
							first_available_position := pos
						else
							pos := first_available_position
						end
					end
				end
			end
			if not break then
				control := Not_found_constant
				if first_available_position >= 0 then
					pos := first_available_position
				end
			end
			position := pos
		end

	soon_full: BOOLEAN
		-- Is `Current' close to being filled?
		-- (If so, resizing is needed to avoid performance degradation.)
		do
			Result := (content.count * Size_threshold <= 100 * count)
		end

feature {NONE} -- Deferred

	resize (n: INTEGER)
		-- Resize table to accommodate `n' elements.
		require
			n_non_negative: n >= 0
			n_greater_than_count: n >= count
		deferred
		end

feature {EL_HASH_SET_IMPLEMENTATION, EL_HASH_SET_ITERATION_CURSOR} -- Internal attributes access

	content: SPECIAL [detachable H]
		-- Content

	insertion_marks: SPECIAL [BOOLEAN]
		-- insertion marks

feature {NONE} -- Internal attributes

	control: INTEGER
		-- Control code set by operations that may return
		-- several possible conditions.
		-- Possible control codes are the following:

	iteration_position: INTEGER
		-- Iteration position value

	position: INTEGER
		-- Hash table cursor

feature {NONE} -- Status constants

	Changed: INTEGER = 3
		-- Change successful

	Found_constant: INTEGER = 2
		-- Key found

	Insertion_conflict: INTEGER = 5
		-- Could not insert an already existing key

	Insertion_ok: INTEGER = 1
		-- Insertion successful

	Not_found_constant: INTEGER = 6
		-- Key not found

	Removed: INTEGER = 4
		-- Remove successful

feature {NONE} -- Constants

	Size_threshold: INTEGER = 80
		-- Filling percentage over which some resizing is done

invariant
	count_big_enough: 0 <= count
	consistent_insertions: insertion_count = count

end