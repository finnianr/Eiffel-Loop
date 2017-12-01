note
	description: "Arrayed list of key-value pair tuples"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-16 7:03:30 GMT (Thursday 16th November 2017)"
	revision: "1"

class
	EL_ARRAYED_MAP_LIST [K -> HASHABLE, G]

inherit
	EL_ARRAYED_LIST [TUPLE [key: K; value: G]]
		rename
			extend as map_extend
		end

create
	make, make_filled, make_from_array, make_empty, make_from_table

feature {NONE} -- Initialization

	make_from_table (table: HASH_TABLE [G, K])
		do
			make (table.count)
			from table.start until table.after loop
				extend (table.key_for_iteration, table.item_for_iteration)
				table.forth
			end
		end

feature -- Access

	first_key: K
		do
			Result := first.key
		end

	first_value: G
		do
			Result := first.value
		end

	item_key: K
		do
			Result := item.key
		end

	item_value: G
		do
			Result := item.value
		end

	last_key: K
		do
			Result := last.key
		end

	last_value: G
		do
			Result := last.value
		end

	value_list: EL_ARRAYED_LIST [G]
		do
			create Result.make (count)
			do_all (agent extend_value_list (Result, ?))
		end

	key_list: EL_ARRAYED_LIST [K]
		do
			create Result.make (count)
			do_all (agent extend_key_list (Result, ?))
		end

feature -- Element change

	extend (key: K; value: G)
		do
			map_extend ([key, value])
		end

feature -- Conversion

	as_string_32_list (joined: FUNCTION [K, G, STRING_32]): EL_ARRAYED_LIST [STRING_32]
		do
			create Result.make (count)
			do_all (agent extend_string_32_list (Result, joined, ?))
		end

	as_string_8_list (joined: FUNCTION [K, G, STRING_8]): EL_ARRAYED_LIST [STRING_8]
		do
			create Result.make (count)
			do_all (agent extend_string_8_list (Result, joined, ?))
		end

	as_string_list (joined: FUNCTION [K, G, ZSTRING]): EL_ARRAYED_LIST [ZSTRING]
		do
			create Result.make (count)
			do_all (agent extend_string_list (Result, joined, ?))
		end

feature {NONE} -- Implementation

	extend_string_32_list (list: like as_string_32_list; joined: FUNCTION [K, G, STRING_32]; a_item: like item)
		do
			list.extend (joined (a_item.key, a_item.value))
		end
	extend_string_8_list (list: like as_string_8_list; joined: FUNCTION [K, G, STRING_8]; a_item: like item)
		do
			list.extend (joined (a_item.key, a_item.value))
		end

	extend_string_list (list: like as_string_list; joined: FUNCTION [K, G, ZSTRING]; a_item: like item)
		do
			list.extend (joined (a_item.key, a_item.value))
		end

	extend_value_list (list: like value_list; a_item: like item)
		do
			list.extend (a_item.value)
		end

	extend_key_list (list: like key_list; a_item: like item)
		do
			list.extend (a_item.key)
		end

end
