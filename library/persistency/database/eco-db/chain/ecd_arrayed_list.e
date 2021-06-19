note
	description: "[
		Provides the features below when used in conjunction with either of these 2 classes:
		
			1. [$source ECD_CHAIN [EL_STORABLE]]
			2. [$source ECD_RECOVERABLE_CHAIN [EL_STORABLE]]

		from the [./library/Eco-DB.html Eco-DB library].
		
		* An Eiffel-orientated data query language via the features of [$source EL_CHAIN] and [$source EL_QUERYABLE_CHAIN].
		The class [$source EL_QUERYABLE_ARRAYED_LIST] has links to some examples in the
		[./example/manage-mp3/manage-mp3.html mp3-manager] project.
		
		* Automatically maintained field indexes accessible via the tuple attribute `index_by'
		
		* Automatic maintenance of a primary key index when used in conjunction with class
		[$source ECD_PRIMARY_KEY_INDEXABLE [EL_KEY_IDENTIFIABLE_STORABLE]]
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-19 8:24:31 GMT (Saturday 19th June 2021)"
	revision: "15"

class
	ECD_ARRAYED_LIST [G -> EL_STORABLE create make_default end]

inherit
	EL_QUERYABLE_ARRAYED_LIST [G]
		redefine
			make, extend, replace, wipe_out
		end

feature {NONE} -- Initialization

	make (n: INTEGER)
		local
			i: INTEGER; index_list: like index_tables; group_list: like group_tables
		do
			Precursor (n)
			index_by := new_index_by
			create index_list.make_empty (index_by.count + 1) -- Allow enough room for primary key index
			from i := 1 until i > index_by.count loop
				if attached {like index_tables.item} index_by.reference_item (i) as table then
					index_list.extend (table)
				end
				i := i + 1
			end
			make_index_by_key (index_list)
			index_tables := index_list

			group_by := new_group_by
			create group_list.make_empty (group_by.count)
			from i := 1 until i > group_by.count loop
				if attached {like group_tables.item} group_by.reference_item (i) as table then
					group_list.extend (table)
				end
				i := i + 1
			end
			group_tables := group_list
		end

	make_index_by_key (index_list: like index_tables)
			-- Implement this by inheriting class `ECD_PRIMARY_KEY_INDEXABLE' and undefining
			-- this routine
		require
			big_enough: index_list.count < index_list.capacity
		do
		end

feature -- Access

	index_by: like new_index_by

	group_by: like new_group_by

feature -- Element change

	extend (a_item: like item)
		require else
			unique_key_in_all_indexes: not not_some_index_has (a_item)
		do
			assign_key (a_item)
			Precursor (a_item)
			index_tables.do_all_in_bounds (agent {like index_tables.item}.on_extend (a_item), 0, index_tables.count - 1)
			group_tables.do_all_in_bounds (agent {like group_tables.item}.list_extend (a_item), 0, group_tables.count - 1)
		end

	replace (a_item: like item)
		do
			assign_key (a_item)
			index_tables.do_all_in_bounds (agent {like index_tables.item}.on_replace (a_item), 0, index_tables.count - 1)
			group_tables.do_all_in_bounds (
				agent {like group_tables.item}.list_replace (item, a_item), 0, group_tables.count - 1
			)
			Precursor (a_item)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			index_tables.do_all_in_bounds (agent {like index_tables.item}.wipe_out, 0, index_tables.count - 1)
			group_tables.do_all_in_bounds (agent {like group_tables.item}.wipe_out, 0, group_tables.count - 1)
		end

feature -- Contract Support

	not_some_index_has (a_item: like item): BOOLEAN
		do
			Result := not index_tables.there_exists_in_bounds (
				agent {like index_tables.item}.has, 0, index_tables.count - 1
			)
		end

feature {NONE} -- Factory

	new_group_by: TUPLE
		do
			create Result
		end

	new_index_by: TUPLE
		do
			create Result
		end

	new_group_by_natural (field_function: FUNCTION [G, NATURAL]): EL_GROUP_TABLE [G, NATURAL]
		do
			create Result.make (field_function, capacity)
		end

	new_index_by_byte_array (field_function: FUNCTION [G, EL_BYTE_ARRAY]): ECD_AGENT_INDEX_TABLE [G, EL_BYTE_ARRAY]
		-- for use with class `EL_DIGEST_ARRAY' in encryption library
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string (field_function: FUNCTION [G, ZSTRING]): ECD_AGENT_INDEX_TABLE [G, ZSTRING]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_32 (field_function: FUNCTION [G, STRING_32]): ECD_AGENT_INDEX_TABLE [G, STRING_32]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_8 (field_function: FUNCTION [G, STRING_8]): ECD_AGENT_INDEX_TABLE [G, STRING_8]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_uuid (field_function: FUNCTION [G, EL_UUID]): ECD_AGENT_INDEX_TABLE [G, EL_UUID]
		do
			create Result.make (Current, field_function, capacity)
		end

feature {NONE} -- Event handler

	on_delete
		require
			item_deleted: item.is_deleted
		do
			index_tables.do_all_in_bounds (agent {like index_tables.item}.on_delete (item), 0, index_tables.count - 1)
			group_tables.do_all_in_bounds (agent {like group_tables.item}.list_delete (item), 0, group_tables.count - 1)
		end

feature {NONE} -- Implementation

	assign_key (identifiable: EL_STORABLE)
			-- Implement this by inheriting class `ECD_PRIMARY_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

	current_list: ECD_ARRAYED_LIST [G]
		do
			Result := Current
		end

feature {NONE} -- Internal attributes

	group_tables: SPECIAL [EL_GROUP_TABLE [G, HASHABLE]]

	index_tables: SPECIAL [ECD_INDEX_TABLE [G, HASHABLE]];

note
	instructions: "[
		To create field indexes for a list, inherit from [$source ECD_ARRAYED_LIST] or
		[$source ECD_REFLECTIVE_RECOVERABLE_CHAIN] and redefine the function `new_index_by' with
		any number of index members as in this example:

			deferred class
				CUSTOMER_LIST

			inherit
				ECD_ARRAYED_LIST [CUSTOMER]
					undefine
						assign_key, make_index_by_key
					redefine
						new_index_by
					end

				KEY_INDEXABLE [CUSTOMER]
					undefine
						is_equal, copy
					end

			feature {NONE} -- Factory

				new_index_by: TUPLE [email: like new_index_by_string]
					do
						Result := [new_index_by_string (agent {CUSTOMER}.email)]
					end
	]"

end