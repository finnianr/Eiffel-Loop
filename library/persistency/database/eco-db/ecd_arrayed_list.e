note
	description: "[
		Provides the following features when used in conjunction with the classes [$source ECD_CHAIN] or
		[$source ECD_RECOVERABLE_CHAIN] from the
		[./library/Eco-DB.html Eco-DB library]:
		
		* An Eiffel orientated data query language via the features of [$source EL_QUERYABLE_CHAIN]. The
		class [$source EL_QUERYABLE_ARRAYED_LIST] has links to some examples in the
		[./example/manage-mp3/manage-mp3.html mp3-manager] project.
		
		* Automatically maintained field indexes accessible via the tuple attribute `index_by'
		
		* Automatic maintenance of a primary key index when used in conjunction with class [$source ECD_PRIMARY_KEY_INDEXABLE]
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 19:12:45 GMT (Tuesday   1st   October   2019)"
	revision: "6"

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
			-- Implement this by inheriting class `ECD_PRIMARY_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

feature -- Access

	index_by: like new_index_by

	index_tables: LINEAR [ECD_LIST_INDEX [G, HASHABLE]]

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

	new_index_by_string (field_function: FUNCTION [G, ZSTRING]): ECD_LIST_INDEX [G, ZSTRING]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_8 (field_function: FUNCTION [G, STRING_8]): ECD_LIST_INDEX [G, STRING_8]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_string_32 (field_function: FUNCTION [G, STRING_32]): ECD_LIST_INDEX [G, STRING_32]
		do
			create Result.make (Current, field_function, capacity)
		end

	new_index_by_uuid (field_function: FUNCTION [G, EL_UUID]): ECD_LIST_INDEX [G, EL_UUID]
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
			-- Implement this by inheriting class `ECD_PRIMARY_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

	current_list: ECD_ARRAYED_LIST [G]
		do
			Result := Current
		end

note
	instructions: "[
		To create field indexes for a list, inherit from [$source ECD_ARRAYED_LIST] or
		[$source ECD_REFLECTIVE_ARRAYED_LIST] and redefine the function `new_index_by' with
		any number of index members as in this example:

			deferred class
				CUSTOMER_LIST

			inherit
				ECD_REFLECTIVE_ARRAYED_LIST [CUSTOMER]
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
