note
	description: "Arrayed list of key-value pair tuples"
	descendants: "[
			EL_ARRAYED_MAP_LIST
				[$source EL_SORTABLE_ARRAYED_MAP_LIST]*
					[$source EL_KEY_SORTABLE_ARRAYED_MAP_LIST]
					[$source EL_VALUE_SORTABLE_ARRAYED_MAP_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-27 14:46:37 GMT (Friday 27th December 2019)"
	revision: "6"

class
	EL_ARRAYED_MAP_LIST [K, G]

inherit
	EL_ARRAYED_LIST [TUPLE [key: K; value: G]]
		rename
			extend as map_extend
		end

create
	make, make_filled, make_from_array, make_empty,
	make_from_keys, make_from_table, make_from_values

feature {NONE} -- Initialization

	make_from_keys (container: FINITE [K]; to_value: FUNCTION [K, G])
		require
			iterable_container: attached {ITERABLE [G]} container
		do
			make (container.count)
			if attached {ITERABLE [K]} container as list then
				across list as key loop
					extend (key.item, to_value (key.item))
				end
			end
		end

	make_from_table (table: TABLE_ITERABLE [G, K])
		local
			table_count: INTEGER
		do
			if attached {FINITE [G]} table as finite then
				table_count := finite.count
			else
				across table as t loop
					table_count := table_count + 1
				end
			end
			make (table_count)
			across table as value loop
				extend (value.key, value.item)
			end
		end

	make_from_values (container: FINITE [G]; to_key: FUNCTION [G, K])
		require
			iterable_container: attached {ITERABLE [G]} container
		do
			make (container.count)
			if attached {ITERABLE [G]} container as list then
				across list as value loop
					extend (to_key (value.item), value.item)
				end
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

	key_list: EL_ARRAYED_LIST [K]
		do
			create Result.make (count)
			do_all (agent extend_key_list (Result, ?))
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

feature -- Cursor movement

	key_search (key: K)
		local
			l_area: like area_v2; i, nb: INTEGER; match_found: BOOLEAN
		do
			l_area := area_v2
			from nb := count - 1; i := index - 1 until i > nb or match_found loop
				if key ~ l_area.item (i).key then
					match_found := True
				else
					i := i + 1
				end
			end
			index := i + 1
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

	extend_key_list (list: like key_list; a_item: like item)
		do
			list.extend (a_item.key)
		end

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

end
