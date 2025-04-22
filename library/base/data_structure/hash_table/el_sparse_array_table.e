note
	description: "[
		Table abstraction that is implemented either as an array or a table depending on which has the
		greater memory saving for the hash table data specified in `make' routine.
		The key type must be convertible to an array index, i.e. an ${INTEGER_32} value.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 16:44:34 GMT (Tuesday 22nd April 2025)"
	revision: "1"

deferred class
	EL_SPARSE_ARRAY_TABLE [G, K -> HASHABLE]

inherit
	EL_HASH_TABLE [G, K]
		rename
			make as make_sized
		export
			{NONE} all
		redefine
			has, item, valid_key
		end

	EL_MODULE_EIFFEL

	EL_OBJECT_PROPERTY_I

feature {NONE} -- Initialization

	make (a_table: HASH_TABLE [G, K])
		local
			index_upper, value, array_count: INTEGER; is_value_expanded: BOOLEAN
			table_size, i: INTEGER; array: SPECIAL [G]
		do
			is_value_expanded := ({G}).is_expanded
			default_value_index := -1

			index_upper := value.Min_value
			index_lower := value.Max_value
			across a_table as table loop
				value := as_integer (table.key)
				index_lower := value.min (index_lower)
				index_upper := value.max (index_upper)
			end
			array_count := index_upper - index_lower + 1

			across <<
				a_table.deleted_marks, a_table.indexes_map, a_table.keys, a_table.content
			>> as structure loop
				table_size := table_size + property (structure.item).physical_size
			end
			create array.make_filled (computed_default_value, array_count)
			if table_size < property (array).physical_size then
				copy_from (a_table)
			else
				across a_table as table loop
					i := as_integer (table.key) - index_lower
					array [i] := table.item
					if is_value_expanded and then array [i] = computed_default_value then
						default_value_index := i
					end
				end
				deleted_marks := Empty_deleted_marks
				indexes_map := Empty_indexes_map
				create keys.make_empty (0)
				content := array
			end
		end

feature -- Access

	item alias "[]" (key: K): detachable G
		do
			if deleted_marks = Empty_deleted_marks then
				Result := content [as_integer (key) - index_lower]
			else
				Result := Precursor {EL_HASH_TABLE} (key)
			end
		end

feature -- Status query

	has (key: K): BOOLEAN
		local
			i: INTEGER
		do
			if is_array_indexed then
				i := as_integer (key) - index_lower
				if content.valid_index (i) then
					if default_value_index = i then
						Result := True
					else
						Result := content [i] /= computed_default_value
					end
				end
			else
				Result := Precursor {EL_HASH_TABLE} (key)
			end
		end

	is_array_indexed: BOOLEAN
		do
			Result := deleted_marks = Empty_deleted_marks
		end

	valid_key (key: K): BOOLEAN
		do
			if is_array_indexed then
				Result := content.valid_index (as_integer (key) - index_lower)
			else
				Result := Precursor {EL_HASH_TABLE} (key)
			end
		end

feature {NONE} -- Implementation

	copy_from (other: HASH_TABLE [G, K])
		local
			unexported_fields: STRING
		do
			capacity := other.capacity
			content := other.content
			control := other.control
			count := other.count
			deleted_item_position := other.deleted_item_position
			deleted_marks := other.deleted_marks
			found_item := other.found_item
			has_default := other.has_default
			indexes_map := other.indexes_map
			iteration_position := other.iteration_position
			item_position := other.item_position
			iteration_position := other.iteration_position
			keys := other.keys
			object_comparison := other.object_comparison

			unexported_fields := "[
				hash_table_version_64, ht_lowest_deleted_position, ht_deleted_key, ht_deleted_item
			]"
			Eiffel.copy_fields (other, Current, unexported_fields)
		end

feature -- Deferred

	as_integer (a_key: K): INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	index_lower: INTEGER

	default_value_index: INTEGER

feature {NONE} -- Constants

	Empty_deleted_marks: SPECIAL [BOOLEAN]
		once ("PROCESS")
			create Result.make_empty (0)
		end

	Empty_indexes_map: SPECIAL [INTEGER]
		once ("PROCESS")
			create Result.make_empty (0)
		end

end