note
	description: "Hash set"
	notes: "[
		Tried implementing this with class [$source SEARCH_TABLE] but there seems to be some problems
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-16 11:49:09 GMT (Sunday 16th October 2022)"
	revision: "19"

class
	EL_HASH_SET [H -> HASHABLE]

inherit
	TRAVERSABLE_SUBSET [detachable H]
		rename
			extend as put,
			item as iteration_item,
			remove as remove_item,
			linear_representation as to_list
		undefine
			is_equal, copy, default_create
		redefine
			compare_objects, compare_references, is_subset
		end

	SEARCH_TABLE [detachable H]
		rename
			conflict as conflict_constant,
			disjoint as ht_disjoint,
			linear_representation as to_list,
			item_for_iteration as iteration_item,
			inserted as inserted_constant,
			merge as ht_merge,
			make_map as make_size,
			prune as ht_prune,
			remove as prune
		export
			{NONE} all
			{ANY} has, valid_key, found, found_item, search, count, new_cursor,
				 wipe_out, iteration_item
		redefine
			make, make_size, put, same_keys
		end

	TRAVERSABLE [H]
		rename
			linear_representation as to_list,
			item as iteration_item
		undefine
			changeable_comparison_criterion, compare_objects, compare_references, copy, is_equal
		end

	EL_MODULE_ITERABLE

create
	make, make_size, make_from_array, make_from

convert
	make_from_array ({ARRAY [H]})

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate hash table for at least `n' items using `~' for comparison.
			-- The table will be resized automatically if more than `n' items are inserted.
		do
			Precursor (n)
			object_comparison := True
		end

	make_from (container: CONTAINER [H]; a_object_comparison: BOOLEAN)
		local
			wrapper: EL_CONTAINER_WRAPPER [H]; l_count: INTEGER
		do
			create wrapper.make (container)
			l_count := wrapper.count
			if a_object_comparison then
				make (l_count)
			else
				make_size (l_count)
			end
			wrapper.do_for_all (agent put)
			if count > 100 and then (count / l_count) < 0.5 then
				make_from (to_list, a_object_comparison)
			end
		end

	make_from_array (array: ARRAY [H])
		do
			make_from (array, True)
		end

	make_size (n: INTEGER)
		do
			Precursor (n)
		end

feature -- Access

	subset (is_member: PREDICATE [H]; inverse: BOOLEAN): like Current
		local
			i, table_size: INTEGER; include: BOOLEAN
			current_key: detachable H
			local_content: like content
		do
			if object_comparison then
				create Result.make (count // 2)
			else
				create Result.make_size (count // 2)
			end
			local_content := content
			table_size := local_content.count
			from until i >= table_size loop
				current_key := local_content.item (i)
				if current_key /= Void and then valid_key (current_key) then
					include := is_member (current_key)
					if inverse then
						include := not include
					end
					if include then
						Result.put (current_key)
					end
				end
				i := i + 1
			end
		end

	subset_exclude (is_member: PREDICATE [H]): like Current
		do
			Result := subset (is_member, True)
		end

	subset_include (is_member: PREDICATE [H]): like Current
		do
			Result := subset (is_member, False)
		end

	to_representation: EL_HASH_SET_REPRESENTATION [H]
		-- to representation applied to reflected field of type `H'
		do
			create Result.make (Current)
		end

feature -- Status query

	has_key (key: H): BOOLEAN
		-- Is `access_key' currently used?
		-- (Shallow equality)
		do
			search (key)
			Result := (control = Found_constant)
		end

	inserted: BOOLEAN
			-- Did last operation insert an item?
		do
			Result := (control = Inserted_constant)
		end

	conflict: BOOLEAN
			-- Did last operation insert an item?
		do
			Result := (control = Conflict_constant)
		end

feature -- Comparison

	is_subset (other: TRAVERSABLE_SUBSET [H]): BOOLEAN
		-- Is current set a subset of `other'?
		local
			current_key: detachable H; local_content: like content
			i, table_size: INTEGER
		do
			if is_empty then
				Result := True

			elseif not other.is_empty and then count <= other.count then
				local_content := content
				table_size := local_content.count
				from Result := True until i >= table_size or not Result loop
					current_key := local_content.item (i)
					if current_key /= Void and then valid_key (current_key) then
						Result := other.has (current_key)
					end
					i := i + 1
				end
			end
		end

	same_keys (a_search_key, a_key: H): BOOLEAN
		-- Does `a_search_key' equal to `a_key'?
		--| Default implementation is using ~.
		do
			if object_comparison then
				Result := a_search_key ~ a_key
			else
				Result := a_search_key = a_key
			end
		end

feature -- Duplication

	duplicate (n: INTEGER): EL_HASH_SET [H]
		do
			if object_comparison then
				create Result.make (n)
			else
				create Result.make_size (n)
			end
			Result.copy (Current)
		end

feature -- Element change

	put (key: H)
		-- In either case, set `found_item' to the item
		-- now associated with `key' (previous item if
		-- there was one, `new' otherwise).
		do
			Precursor (key)
			if control = Conflict_constant then
				found_item := content.item (position)
			else
				found_item := key
			end
		ensure then
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
		require
			valid_key (key)
		do
			internal_search (key)
			if control = Found_constant then
				control := Conflict_constant
				found_item := content.item (position)
			else
				if soon_full then
					add_space
					internal_search (key)
				end
				found_item := key.twin
				content.put (found_item, position)
				count := count + 1
				control := Inserted_constant
			end
		ensure then
			insertion_done: control = Inserted_constant implies item (key) ~ key and item (key) /= key
			item_if_found: found_item = content.item (position)
		end

	remove_item
		do
			prune (key_for_iteration)
		end

feature -- Status setting

	compare_objects
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		do
			object_comparison := True
			is_map := False
		end

	compare_references
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		do
			object_comparison := False
			is_map := True
		end

feature -- Status query

	Extendible: BOOLEAN = True
		-- May new items be added?

feature {NONE} -- Implementation

	subset_strategy_selection (v: H; other: EL_HASH_SET [H]): SUBSET_STRATEGY_HASHABLE [H]
			-- Strategy to calculate several subset features selected depending
			-- on the dynamic type of `v' and `other'
		do
			create Result
		end

feature {NONE} -- Constants

	Prunable: BOOLEAN = True

end