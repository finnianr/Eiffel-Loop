note
	description: "Table to count number of attempts to insert key with `put' routine"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-23 16:19:45 GMT (Tuesday 23rd January 2024)"
	revision: "4"

class
	EL_COUNTER_TABLE [K -> HASHABLE]

inherit
	HASH_TABLE [NATURAL_32_REF, K]
		rename
			put as put_item,
			found_item as found_count
		export
			{NONE} force, extend, put_item
		end

create
	make, make_equal

feature -- Access

	as_sorted_list (in_ascending_order: BOOLEAN): EL_ARRAYED_MAP_LIST [K, NATURAL]
		do
			create Result.make (count)
			from start until after loop
				Result.extend (key_for_iteration, item_for_iteration.item)
				forth
			end
			Result.sort_by_value (in_ascending_order)
		end

	sum_count: NATURAL
		-- sum of all insertion counts
		do
			from start until after loop
				Result := Result + item_for_iteration.item
				forth
			end
		end

feature -- Element change

	put (v: K)
		local
			put_count: NATURAL_32_REF
		do
			if has_key (v) then
				put_count := found_count
			else
				create put_count
				extend (put_count, v)
			end
			put_count.set_item (put_count.item + 1)
		end

end