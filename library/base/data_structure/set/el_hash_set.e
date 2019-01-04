note
	description: "Hash set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-01 16:06:08 GMT (Tuesday 1st January 2019)"
	revision: "6"

class
	EL_HASH_SET [G -> HASHABLE]

inherit
	HASH_TABLE [detachable G, detachable G]
		rename
			put as table_put,
			extend as table_extend,
			item_for_iteration as item,
			item as table_item,
			current_keys as to_array
		export
			{NONE} all
			{ANY} has, has_key, found, found_item, search, remove, count,
				 inserted, to_array, wipe_out, conflict, key_for_iteration, item
		end

	LINEAR [detachable G]
		rename
			has as has_item
		undefine
			copy, is_equal, off, search, linear_representation, occurrences, has_item
		end

create
	make, make_equal, make_from_array

feature {NONE} -- Initialization

	make_from_array (set: ARRAY [G])
		do
			make_equal (set.count)
			set.do_all (agent put)
		end

feature -- Element change

	put (new: detachable G)
			--
		do
			table_put (new, new)
		end

	extend (new: detachable G)
			--
		do
			table_extend (new, new)
		end

feature -- Access

	index: INTEGER

	subset_include (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, False)
		end

	subset_exclude (is_member: PREDICATE [G]): like Current
		do
			Result := subset (is_member, True)
		end

	subset (is_member: PREDICATE [G]; inverse: BOOLEAN): like Current
		do
			if object_comparison then
				create Result.make_equal (count // 2)
			else
				create Result.make (count // 2)
			end
			from start until after loop
				if inverse then
					if not is_member (item_for_iteration) then
						Result.put (item_for_iteration)
					end
				else
					if is_member (item_for_iteration) then
						Result.put (item_for_iteration)
					end
				end
				forth
			end
		end

feature {NONE} -- Unused

	finish
			--
		do
		end

end
