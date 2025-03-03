note
	description: "Hash set implementing ${EL_SET [H]}"
	descendants: "[
			EL_HASH_SET [H -> ${HASHABLE}]
				${EL_MEMBER_SET [G -> EL_SET_MEMBER [G]]}
				${EL_FIELD_NAME_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-03 9:16:09 GMT (Monday 3rd March 2025)"
	revision: "37"

class
	EL_HASH_SET [H -> HASHABLE]

inherit
	EL_HASH_SET_BASE [H]
		export
			{EL_HASH_SET, EL_HASH_SET_ITERATION_CURSOR} append_to, content, key_tester, set_key_tester
		redefine
			copy, is_equal, is_subset, intersect, subtract
		end

	EL_CONTAINER_STRUCTURE [H]
		rename
			current_container as current_table,
			intersection as intersection_query
		undefine
			count, copy, is_equal, object_comparison
		end

	ITERABLE [H]
		undefine
			copy, is_equal
		end

	TRAVERSABLE [H]
		rename
			item as iteration_item
		undefine
			copy, changeable_comparison_criterion, compare_objects, compare_references,
			is_equal
		end

	EL_SET [H]
		undefine
			copy, is_equal
		end

create
	make_equal, make, make_equal_array, make_from, make_from_special

convert
	make_equal_array ({ARRAY [H]})

feature {NONE} -- Initialization

	make (n: INTEGER)
		-- Allocate hash table for at least `n' items using `=' for comparison.
		-- The table will be resized automatically if more than `n' items are inserted.
		require
			n_non_negative: n >= 0
		do
			make_with_key_tester (n, Void)
			compare_references
		ensure
			capacity_big_enough: capacity >= n
			reference_comparison: reference_comparison
		end

	make_equal (n: INTEGER)
		-- Allocate hash table for at least `n' items using `~' for comparison.
		-- The table will be resized automatically if more than `n' items are inserted.
		require
			n_non_negative: n >= 0
		do
			make_with_key_tester (n, Void)
			compare_objects
		ensure
			capacity_big_enough: capacity >= n
		end

	make_equal_array (array: ARRAY [H])
		do
			make_equal (array.count)
			array.do_all (agent put)
		end

	make_from (container: CONTAINER [H]; a_object_comparison: BOOLEAN)
		do
			if attached as_structure (container) as structure then
				make (structure.count)

		-- May `object_comparison' be changed ?
		-- (Answer: only if set empty; otherwise insertions might
		-- introduce duplicates, destroying the set property.)
				object_comparison := a_object_comparison

				structure.do_for_all (agent put)
			else
				make (0)
				object_comparison := a_object_comparison
			end
		end

	make_from_special (area: SPECIAL [H]; a_object_comparison: BOOLEAN)
		local
			i: INTEGER
		do
			make (area.count)
			object_comparison := a_object_comparison
			from i := 0 until i = area.count loop
				put (area [i])
				i := i + 1
			end
		end

feature -- Access

	new_cursor: EL_HASH_SET_ITERATION_CURSOR [H]
		-- <Precursor>
		do
			create Result.make (Current)
		end

	subset (is_member: PREDICATE [H]; inverse: BOOLEAN): like Current
		local
			include: BOOLEAN; subset_area: SPECIAL [H]
			pos, last_index: INTEGER; break: BOOLEAN
			area_item: H
		do
			create subset_area.make_empty (capacity)
			if attached content as area and then attached insertion_marks as l_inserted then
				last_index := capacity - 1
				from pos := -1 until break loop
					pos := next_iteration_index (pos, last_index, l_inserted)
					if pos > last_index then
						break := True
					else
						area_item := area [pos]
						include := is_member (area_item)
						if inverse then
							include := not include
						end
						if include then
							subset_area.extend (area_item)
						end
					end
				end
			end
			create Result.make_from_special (subset_area, object_comparison)
		end

	subset_exclude (is_member: PREDICATE [H]): like Current
		do
			Result := subset (is_member, True)
		end

	subset_include (is_member: PREDICATE [H]): like Current
		do
			Result := subset (is_member, False)
		end

	to_list, linear_representation: EL_ARRAYED_LIST [H]
		local
			pos, last_index: INTEGER; break: BOOLEAN
			area: SPECIAL [H]
		do
			create area.make_empty (count)
			if attached content as l_content and then attached insertion_marks as l_inserted then
				last_index := capacity - 1
				from pos := -1 until break loop
					pos := next_iteration_index (pos, last_index, l_inserted)
					if pos > last_index then
						break := True
					else
						area.extend (l_content [pos])
					end
				end
			end
			create Result.make_from_special (area)
		end

	to_representation: EL_HASH_SET_REPRESENTATION [H]
		-- to representation applied to reflected field of type `H'
		do
			create Result.make (Current)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		-- Does table contain the same information as `other'?
		local
			pos, last_index: INTEGER; break: BOOLEAN
		do
			if Current = other then
				Result := True

			elseif count = other.count and then object_comparison = other.object_comparison
				and then key_tester ~ other.key_tester
			then
				if attached content as area and then attached insertion_marks as l_inserted then
					last_index := capacity - 1
					Result := True
					from pos := -1 until not Result or break loop
						pos := next_iteration_index (pos, last_index, l_inserted)
						if pos > last_index then
							break := True
						else
							Result := other.has (area [pos])
						end
					end
				end
			end
		end

	is_subset (other: TRAVERSABLE_SUBSET [H]): BOOLEAN
		-- Is `Current' set a subset of `other' ?
		local
			pos, last_index: INTEGER; break: BOOLEAN
		do
			if is_empty then
				Result := True

			elseif not other.is_empty and then count <= other.count
				and then attached content as area and then attached insertion_marks as l_inserted
			then
				last_index := capacity - 1; Result := True
				from pos := -1 until break or not Result loop
					pos := next_iteration_index (pos, last_index, l_inserted)
					if pos > last_index then
						break := True
					else
						Result := other.has (area [pos])
					end
				end
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

	duplicate (n: INTEGER): like Current
		do
			create Result.make (0)
			Result.copy (Current)
		end

feature -- Basic operations

	accommodate (n: INTEGER)
		-- Reallocate table with enough space for `n' items;
		-- keep all current items.
		do
			resize (n.max (count))
		end

	intersect (other: TRAVERSABLE_SUBSET [H])
		-- Remove all items not in `other'.
		-- No effect if `other' `is_empty'.
		do
			if not other.is_empty then
				query_not_in (other).do_all (agent prune)
			else
				wipe_out
			end
		end

	resize (n: INTEGER)
		-- Resize table to accommodate `n' elements.
		do
			if (content.count * Size_threshold <= 100 * n) and then attached empty_duplicate (n) as new then
				append_to (new)
				standard_copy (new)
			end
		end

	search (key: H)
		-- Search for item of key `key'
		-- If found, set `found' to True, and set
		-- `found_item' to item associated with `key'.
		local
			default_value: detachable H
		do
			internal_search (key)
			inspect control
				when Found_constant then
					found_item := content.item (position)
			else
				found_item := default_value
			end
		end

feature -- Removal

	prune (key: H)
		-- Remove item associated with `key', if present.
		-- Set `control' to `Removed' or `Not_found_constant'.
		do
			internal_search (key)
			inspect control
				when Found_constant then
					content.fill_with_default (position, position)
					insertion_marks.put (False, position)
					count := count - 1
			else
			end
		end

	remove_item
		do
			prune (key_for_iteration)
		end

	subtract (other: TRAVERSABLE_SUBSET [H])
		-- Remove all items also in `other'.
		do
			if not (other.is_empty or is_empty) then
				intersection_query (other).do_all (agent prune)
			end
		end

	wipe_out
		-- Reset all items to default values.
		local
			default_value: detachable H
		do
			content.fill_with_default (0, content.count - 1)
			insertion_marks.fill_with_default (0, insertion_marks.count - 1)
			count := 0
			control := 0
			position := 0
			found_item := default_value
		end

feature -- Insertion

	force (key: H)
		-- If `key' is present, replace corresponding item by `new',
		-- if not, insert item `new' with key `key'.
		-- Set `control' to `Insertion_ok'.
		do
			internal_search (key)
			if control /= Found_constant then
				if soon_full then
					expand_size; internal_search (key)
				end
				count := count + 1
			end
			content.put (key, position)
			insertion_marks.put (True, position)
			control := Insertion_ok
		ensure then
			insertion_done: item (key) = key
		end

	merge_other (other: EL_HASH_SET [H])
		-- Merge two search_tables
		do
			if other.count /= 0 then
				resize (count + other.count)
				other.append_to (Current)
			end
		end

	put (key: H)
		-- Attempt to insert `new' with `key'.
		-- Set `control' to `Insertion_ok' or `Insertion_conflict'.
		-- No insertion if conflict.
		do
			internal_search (key)
			inspect control
				when Found_constant then
					control := Insertion_conflict
					found_item := content.item (position)
					inserted := False
			else
				if soon_full then
					expand_size
					internal_search (key)
				end
				content.put (key, position)
				insertion_marks.put (True, position)
				count := count + 1
				control := Insertion_ok
				found_item := key
				inserted := True
			end
		ensure then
			insertion_done: control = Insertion_ok implies item (key) = key
			item_if_found: found implies found_item = content.item (position)
		end

	put_copy (key: H)
		-- put a copy of `key' if not found
		-- In either case, set `found_item' to the item
		-- now associated with `key' (previous item if
		-- there was one, `new' otherwise).
		-- Attempt to insert `new' with `key'.
		-- Set `control' to `Inserted_constant' or `Conflict_constant'.
		-- No insertion if `conflict' is `True'.
		do
			put (key)
			if inserted then
				found_item := key.twin
				content.put (found_item, position)
			end
		ensure then
			insertion_done: inserted implies item (key) ~ key and item (key) /= key
			item_if_found: found_item = content.item (position)
		end

feature -- Cursor movement

	after, off: BOOLEAN
		-- Is the iteration cursor off ?
		do
			Result := iteration_position > capacity - 1
		end

	forth
		-- Advance cursor to next occupied position,
		-- or `off' if no such position remains.
		do
			iteration_position := next_iteration_position (iteration_position)
		end

	go_to (pos: like cursor)
		-- Move to position `pos'.
		require
			valid_cursor: valid_cursor (pos)
		do
			iteration_position := pos
		end

	start
		-- Iteration initialization
		do
			iteration_position := next_iteration_position (-1)
		end

feature -- Contract Support

	valid_cursor (pos: like cursor): BOOLEAN
		-- Can cursor be moved to position `pos'?
		do
			if pos >= capacity or else (pos >= 0 and pos <= capacity) then
				Result := insertion_marks [pos]
			end
		end

feature {NONE} -- Implementation

	current_table: like Current
		do
			Result := Current
		end

	empty_duplicate (n: INTEGER): like Current
		-- Create an empty copy of Current that can accommodate `n' items
		require
			n_non_negative: n >= 0
		local
			tester: like key_tester
		do
			tester := key_tester
			if object_comparison then
				create Result.make_equal (n)
			else
				create Result.make (n)
			end
			Result.set_key_tester (tester)
		ensure
			same_key_tester: Result.key_tester = key_tester
		end

	subset_strategy_selection (v: H; other: EL_HASH_SET [H]): SUBSET_STRATEGY_HASHABLE [H]
		-- Strategy to calculate several subset features selected depending
		-- on the dynamic type of `v' and `other'
		do
			create Result
		end

end