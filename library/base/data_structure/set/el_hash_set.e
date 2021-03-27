note
	description: "Hash set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-25 11:29:50 GMT (Thursday 25th March 2021)"
	revision: "11"

class
	EL_HASH_SET [G -> HASHABLE]

inherit
	EL_HASH_TABLE [detachable G, detachable G]
		rename
			current_keys as to_array,
			disjoint as ht_disjoint,
			extend as ht_extend,
			extendible as ht_extendible,
			linear_representation as to_list,
			item as table_item,
			merge as ht_merge,
			make as make_from_array,
			make_size as make,
			prune as ht_prune,
			remove as prune,
			put as ht_put
		export
			{NONE} all
			{ANY} has, has_key, valid_key, found, found_item, search, count, new_cursor,
				 inserted, to_array, wipe_out, conflict, key_for_iteration, item_for_iteration
		undefine
			changeable_comparison_criterion
		redefine
			is_equal, same_keys
		end

	TRAVERSABLE_SUBSET [detachable G]
		rename
			item as item_for_iteration,
			linear_representation as to_list
		undefine
			is_equal, copy, default_create
		redefine
			is_subset
		select
			put, has, extend, prune, extendible
		end

create
	make, make_equal, make_from_list

feature {NONE} -- Initialization

	make_from_list (list: ITERABLE [G])
		local
			iterable: EL_ITERABLE_ROUTINES
		do
			make_equal (iterable.count (list))
			across list as l loop
				extend (l.item)
			end
		end

feature -- Element change

	extend, put (new: detachable G)
			--
		do
			ht_put (new, new)
		end

	remove
		do
			prune (key_for_iteration)
		end

feature -- Access

	index: INTEGER

	subset (is_member: PREDICATE [G]; inverse: BOOLEAN): like Current
		local
			pos: INTEGER; l_keys: like keys
		do
			if object_comparison then
				create Result.make_equal (count // 2)
			else
				create Result.make (count // 2)
			end
			l_keys := keys
			from pos := next_iteration_position (-1) until is_off_position (pos) loop
				if inverse then
					if not is_member (l_keys.item (pos)) then
						Result.put (l_keys.item (pos))
					end
				else
					if is_member (l_keys.item (pos)) then
						Result.put (l_keys.item (pos))
					end
				end
				pos := next_iteration_position (pos)
			end
		end

	subset_exclude (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, True)
		end

	subset_include (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, False)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		local
			pos: INTEGER
		do
			Result := count = other.count
			from pos := next_iteration_position (-1) until not Result or else is_off_position (pos) loop
				Result := other.has (keys.item (pos))
				pos := next_iteration_position (pos)
			end
		end

	is_subset (other: TRAVERSABLE_SUBSET [G]): BOOLEAN
		-- Is current set a subset of `other'?
		local
			pos: INTEGER; l_keys: like keys
		do
			if not other.is_empty and then count <= other.count then
				from
					l_keys := keys
					pos := next_iteration_position (-1)
				until
					is_off_position (pos) or else not other.has (keys.item (pos))
				loop
					pos := next_iteration_position (pos)
				end
				if is_off_position (pos) then
					Result := True
				end

			elseif is_empty then
				Result := True
			end
		end

	same_keys (a_search_key, a_key: G): BOOLEAN
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

	duplicate (n: INTEGER): EL_HASH_SET [G]
		do
			if object_comparison then
				create Result.make_equal (n)
			else
				create Result.make (n)
			end
			Result.copy (Current)
		end

feature -- Status query

	Extendible: BOOLEAN = True
		-- May new items be added?

feature {NONE} -- Implementation

	subset_strategy_selection (v: G; other: EL_HASH_SET [G]): SUBSET_STRATEGY_HASHABLE [G]
			-- Strategy to calculate several subset features selected depending
			-- on the dynamic type of `v' and `other'
		do
			create Result
		end

end