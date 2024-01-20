note
	description: "[
		Provides the features below when used in conjunction with either of these 2 classes:
		
			1. ${ECD_CHAIN [EL_STORABLE]}
			2. ${ECD_RECOVERABLE_CHAIN [EL_STORABLE]}

		from the [./library/Eco-DB.html Eco-DB library].
		
		* An Eiffel-orientated data query language via the features of ${EL_CHAIN} and ${EL_QUERYABLE_CHAIN}.
		The class ${EL_QUERYABLE_ARRAYED_LIST} has links to some examples in the
		[./example/manage-mp3/manage-mp3.html mp3-manager] project.
		
		* Automatically maintained field indexes accessible via the tuple attribute `index_by'
		
		* Automatic maintenance of a primary key index when used in conjunction with class
		${ECD_PRIMARY_KEY_INDEXABLE [EL_KEY_IDENTIFIABLE_STORABLE]}
	]"
	instructions: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "20"

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
			index_list: EL_ARRAYED_LIST [like index_tables.item]
			field_table: EL_OBJECT_FIELDS_TABLE
		do
			Precursor (n)
			create_index_tables

			create field_table.make (Current, True, True)
			create index_list.make (5)
			across field_table.conforming_type_info_list ({like index_tables.item}) as list loop
				if attached {like index_tables.item} list.item.value_for (Current) as index_field then
					index_list.extend (index_field)
				end
			end
			index_tables := index_list.trimmed_area
		end

feature -- Element change

	extend (a_item: like item)
		require else
			unique_key_in_all_indexes: not not_some_index_has (a_item)
		do
			assign_key (a_item)
			Precursor (a_item)
			index_tables.do_all_in_bounds (agent {like index_tables.item}.on_extend (a_item), 0, index_tables.count - 1)
		end

	replace (a_item: like item)
		do
			assign_key (a_item)
			index_tables.do_all_in_bounds (
				agent {like index_tables.item}.on_replace (item, a_item), 0, index_tables.count - 1
			)
			Precursor (a_item)
		end

feature -- Removal

	wipe_out
		do
			Precursor
			index_tables.do_all_in_bounds (agent {like index_tables.item}.wipe_out, 0, index_tables.count - 1)
		end

feature -- Contract Support

	not_some_index_has (a_item: like item): BOOLEAN
		do
			Result := not index_tables.there_exists_in_bounds (
				agent {like index_tables.item}.has, 0, index_tables.count - 1
			)
		end

feature {NONE} -- Event handler

	on_delete
		require
			item_deleted: item.is_deleted
		do
			index_tables.do_all_in_bounds (agent {like index_tables.item}.on_delete (item), 0, index_tables.count - 1)
		end

feature {NONE} -- Implementation

	assign_key (identifiable: EL_STORABLE)
			-- Implement this by inheriting class `ECD_PRIMARY_KEY_INDEXABLE' and undefining
			-- this routine
		do
		end

	create_index_tables
		do
		end

	current_list: ECD_ARRAYED_LIST [G]
		do
			Result := Current
		end

feature {NONE} -- Internal attributes

	index_tables: SPECIAL [ECD_INDEX [G]];
		-- array of index and group table

note
	instructions: "[
		To create field indexes for a list, inherit from ${ECD_ARRAYED_LIST} or
		${ECD_REFLECTIVE_RECOVERABLE_CHAIN} and redefine the function `new_index_by' with
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