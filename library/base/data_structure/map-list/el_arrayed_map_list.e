note
	description: "Arrayed list of key-value pair tuples"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-15 4:51:18 GMT (Saturday 15th October 2022)"
	revision: "17"

class
	EL_ARRAYED_MAP_LIST [K, G]

inherit
	EL_ARRAYED_LIST [TUPLE [key: K; value: G]]
		rename
			extend as map_extend,
			put_front as map_put_front
		end

create
	make, make_filled, make_from_list, make_empty, make_from_array,
	make_from_keys, make_from_table, make_from_values

feature {NONE} -- Initialization

	make_from_keys (keys: FINITE [K]; to_value: FUNCTION [K, G])
		require
			valid_function: key_item (keys).is_valid_for (to_value)
		local
			saved_cursor: EL_SAVED_CURSOR [K]
		do
			make (keys.count)
			if attached {ITERABLE [K]} keys as list then
				across list as key loop
					extend (key.item, to_value (key.item))
				end

			elseif attached {LINEAR [K]} keys as list then
				create saved_cursor.make (list)
				append_values (list, to_value)
				saved_cursor.restore
			else
				append_values (keys.linear_representation, to_value)
			end
		end

	make_from_table (table: TABLE_ITERABLE [G, K])
		do
			make (Iterable.count (table))
			across table as value loop
				extend (value.key, value.item)
			end
		end

	make_from_values (values: FINITE [G]; to_key: FUNCTION [G, K])
		require
			valid_function: value_item (values).is_valid_for (to_key)
		local
			saved_cursor: EL_SAVED_CURSOR [G]
		do
			make (values.count)
			if attached {ITERABLE [G]} values as list then
				across list as value loop
					extend (to_key (value.item), value.item)
				end

			elseif attached {LINEAR [G]} values as list then
				create saved_cursor.make (list)
				append_keys (list, to_key)
				saved_cursor.restore
			else
				append_keys (values.linear_representation, to_key)
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
		-- search next tuple with key `key' using either reference or object comparison
		-- depending on `object_comparison'
		local
			l_area: like area_v2; i, nb: INTEGER; match_found: BOOLEAN
		do
			l_area := area_v2
			from nb := count - 1; i := index - 1 until i > nb or match_found loop
				if object_comparison then
					match_found := key ~ l_area.item (i).key
				else
					match_found := key = l_area.item (i).key
				end
				if not match_found then
					i := i + 1
				end
			end
			index := i + 1
		end

feature -- Element change

	extend (key: K; value: G)
		do
			map_extend ([key, value])
			if object_comparison then
				last.compare_objects
			else
				last.compare_references
			end
		end

	put_front (key: K; value: G)
		do
			map_put_front ([key, value])
			if object_comparison then
				first.compare_objects
			else
				first.compare_references
			end
		end

	set_key_item (key: like item_key; value: like item_value)
		-- set first `item.value' with key matching `key' or else extend with new key-value tuple
		-- key comparison is either by object or reference depending on `object_comparison'
		do
			push_cursor
			start; key_search (key)
			if found then
				item.value := value
			else
				extend (key, value)
			end
			pop_cursor
		end

feature -- Conversion

	as_string_32_list (a_joined: FUNCTION [K, G, STRING_32]): EL_ARRAYED_LIST [STRING_32]
		do
			create Result.make (count)
			do_all (agent extend_string_32_list (Result, a_joined, ?))
		end

	as_string_8_list (a_joined: FUNCTION [K, G, STRING_8]): EL_ARRAYED_LIST [STRING_8]
		do
			create Result.make (count)
			do_all (agent extend_string_8_list (Result, a_joined, ?))
		end

	as_string_list (a_joined: FUNCTION [K, G, ZSTRING]): EL_ARRAYED_LIST [ZSTRING]
		do
			create Result.make (count)
			do_all (agent extend_string_list (Result, a_joined, ?))
		end

feature -- Contract Support

	key_item (keys: CONTAINER [K]): EL_CONTAINER_ITEM [K]
		do
			create Result.make (keys)
		end

	value_item (values: CONTAINER [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (values)
		end

feature {NONE} -- Implementation

	append_values (keys: LINEAR [K]; to_value: FUNCTION [K, G])
		-- append
		do
			from keys.start until keys.after loop
				extend (keys.item, to_value (keys.item))
				keys.forth
			end
		end

	append_keys (values: LINEAR [G]; to_key: FUNCTION [G, K])
		do
			from values.start until values.after loop
				extend (to_key (values.item), values.item)
				values.forth
			end
		end

	extend_key_list (list: like key_list; a_item: like item)
		do
			list.extend (a_item.key)
		end

	extend_string_32_list (list: like as_string_32_list; a_joined: FUNCTION [K, G, STRING_32]; a_item: like item)
		do
			list.extend (a_joined (a_item.key, a_item.value))
		end

	extend_string_8_list (list: like as_string_8_list; a_joined: FUNCTION [K, G, STRING_8]; a_item: like item)
		do
			list.extend (a_joined (a_item.key, a_item.value))
		end

	extend_string_list (list: like as_string_list; a_joined: FUNCTION [K, G, ZSTRING]; a_item: like item)
		do
			list.extend (a_joined (a_item.key, a_item.value))
		end

	extend_value_list (list: like value_list; a_item: like item)
		do
			list.extend (a_item.value)
		end

note
	descendants: "[
			EL_ARRAYED_MAP_LIST [K, G]
				[$source EL_DECOMPRESSED_DATA_LIST]
				[$source EL_SORTABLE_ARRAYED_MAP_LIST]* [K, G]
					[$source EL_KEY_SORTABLE_ARRAYED_MAP_LIST] [K -> [$source COMPARABLE], G]
					[$source EL_VALUE_SORTABLE_ARRAYED_MAP_LIST] [K, G -> [$source COMPARABLE]]
				[$source EL_STYLED_TEXT_LIST]* [S -> [$source STRING_GENERAL]]
					[$source EL_STYLED_ZSTRING_LIST]
					[$source EL_STYLED_STRING_8_LIST]
					[$source EL_STYLED_STRING_32_LIST]
	]"

end