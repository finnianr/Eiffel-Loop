note
	description: "Summary description for {EL_STORABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-26 10:05:54 GMT (Tuesday 26th December 2017)"
	revision: "2"

class
	EL_STORABLE_LIST [G -> EL_STORABLE create make_default end]

inherit
	EL_ARRAYED_LIST [G]
		redefine
			make, extend, replace, wipe_out
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		local
			i: INTEGER; table_list: ARRAYED_LIST [like index_tables.item]
		do
			Precursor (n)
			index_by := new_index_by
			create table_list.make (index_by.count)
			from i := 1 until i > index_by.count loop
				if attached {like index_tables.item} index_by.reference_item (i) as table then
					table_list.extend (table)
				end
				i := i + 1
			end
			make_index_by_key (table_list)
			index_tables := table_list
		end

	make_index_by_key (table_list: BAG [like index_tables.item])
			-- Implement this by inheriting class `EL_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

feature -- Access

	index_by: like new_index_by

	index_tables: LINEAR [EL_STORABLE_LIST_INDEX [G, HASHABLE]]

feature -- Element change

	extend (a_item: like item)
		require else
			unique_key_in_all_indexes: not not_some_index_has (a_item)
		do
			assign_key (a_item)
			Precursor (a_item)
			index_tables.do_all (agent {like index_tables.item}.on_extend (a_item))
		end

	replace (a_item: like item)
		do
			assign_key (a_item)
			index_tables.do_all (agent {like index_tables.item}.on_replace (a_item))
			Precursor (a_item)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			index_tables.do_all (agent {like index_tables.item}.wipe_out)
		end

feature -- Contract Support

	not_some_index_has (a_item: like item): BOOLEAN
		do
			Result := not index_tables.there_exists (agent {like index_tables.item}.has)
		end

feature {NONE} -- Factory

	new_index_by: TUPLE
		do
			create Result
		end

	new_index_by_string (field_function: FUNCTION [G, ZSTRING]): EL_STORABLE_LIST_INDEX [G, ZSTRING]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_8 (field_function: FUNCTION [G, STRING_8]): EL_STORABLE_LIST_INDEX [G, STRING_8]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_32 (field_function: FUNCTION [G, STRING_32]): EL_STORABLE_LIST_INDEX [G, STRING_32]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_uuid (field_function: FUNCTION [G, EL_UUID]): EL_STORABLE_LIST_INDEX [G, EL_UUID]
		do
			create Result.make (Current, field_function, capacity)
		end

feature {NONE} -- Event handler

	on_delete
		require
			item_deleted: item.is_deleted
		local
			table: like index_tables
		do
			table := index_tables
			from table.start until table.after loop
				table.item.on_delete (item)
				table.forth
			end
		end

feature {NONE} -- Implementation

	assign_key (identifiable: EL_STORABLE)
			-- Implement this by inheriting class `EL_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

	current_list: EL_STORABLE_LIST [G]
		do
			Result := Current
		end

end
