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
	date: "2025-05-05 16:59:25 GMT (Monday 5th May 2025)"
	revision: "7"

deferred class
	EL_SPARSE_ARRAY_TABLE [G, K -> HASHABLE]

inherit
	EL_HASH_TABLE [G, K]
		rename
			make as make_sized,
			previous_iteration_position as table_previous_iteration_position,
			next_iteration_position as table_next_iteration_position
		export
			{NONE} all
			{ANY} after, as_map_list, content, count, forth, found_item, item_list,
					item_for_iteration, key_for_iteration, off, start
		redefine
			forth, has, has_key, key_for_iteration, key_list, is_off_position, item, item_area,
			next_iteration_index, new_cursor, start, valid_key
		end

	EL_MODULE_EIFFEL

	EL_OBJECT_PROPERTY_I

feature {NONE} -- Initialization

	make_empty
		do
			make (create {HASH_TABLE [G, K]}.make (0))
		end

	make (a_table: HASH_TABLE [G, K])
		local
			index_upper, value: INTEGER; is_value_expanded: BOOLEAN
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
			across <<
				a_table.deleted_marks, a_table.indexes_map, a_table.keys, a_table.content
			>> as structure loop
				table_size := table_size + property (structure.item).physical_size
			end
			create array.make_filled (computed_default_value, index_upper - index_lower + 1)
			if table_size < property (array).physical_size then
				copy_from (a_table)
			else
				is_array_indexed := True; count := a_table.count
				across a_table as table loop
					i := as_integer (table.key) - index_lower
					array [i] := table.item
					if is_value_expanded and then array [i] = computed_default_value then
						default_value_index := i
					end
				end
				deleted_marks := Empty_deleted_marks; indexes_map := Empty_indexes_map
				has_default := a_table.has_default -- satisfy `has_key' "default_case" post-condition
				create keys.make_empty (0)
				content := array
				capacity := a_table.count
			end
		end

feature -- Access

	item alias "[]" (key: K): detachable G
		do
			if is_array_indexed then
				Result := content [as_integer (key) - index_lower]
			else
				Result := Precursor (key)
			end
		end

	item_area: SPECIAL [G]
		local
			i, i_upper: INTEGER; i_th_item: like item
		do
			if is_array_indexed and then attached content as l_content then
				create Result.make_empty (count)
				i_upper := l_content.count - 1
				from i := 0 until i > i_upper loop
					i_th_item := l_content [i]
					if i = default_value_index or else i_th_item /= computed_default_value then
						Result.extend (i_th_item)
					end
					i := i + 1
				end
			else
				Result := Precursor
			end
		end

	to_sparse_array: ARRAY [G]
		require
			array_indexed: is_array_indexed
		do
			create Result.make_from_special (content)
			Result.rebase (index_lower)
		end

	key_for_iteration: K
		-- Key at current cursor position
		do
			if is_array_indexed then
				Result := index_to_key (iteration_position + index_lower)
			else
				Result := Precursor
			end
		end

	key_list: EL_ARRAYED_LIST [K]
		local
			i, i_upper: INTEGER; area: SPECIAL [K]
		do
			create area.make_empty (count)
			if is_array_indexed and then attached content as l_content then
				i_upper := l_content.count - 1
				from i := 0 until i > i_upper loop
					if i = default_value_index or else l_content [i] /= computed_default_value then
						area.extend (index_to_key (index_lower + i))
					end
					i := i + 1
				end
				create Result.make_from_special (area)
			else
				Result := Precursor
			end
		end

	new_cursor: EL_SPARSE_ARRAY_TABLE_ITERATION_CURSOR [G, K]
		do
			create Result.make (Current)
			Result.start
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
				Result := Precursor (key)
			end
		end

	has_key (key: K): BOOLEAN
		local
			i: INTEGER; l_item: G
		do
			if is_array_indexed then
				i := as_integer (key) - index_lower
				if content.valid_index (i) then
					l_item := content [i]
					if default_value_index = i then
						Result := True
						found_item := l_item

					else
						Result := content [i] /= computed_default_value
						found_item := l_item

					end
					if Result then
						control := found_constant
					else
						control := not_found_constant
					end
				end
			else
				Result := Precursor (key)
			end
		end

	is_array_indexed: BOOLEAN

	is_off_position (pos: INTEGER): BOOLEAN
			-- Is `pos' a cursor position outside the authorized range?
		do
			if is_array_indexed then
				Result := pos < 0 or pos >= content.count
			else
				Result := Precursor (pos)
			end
		end

	valid_key (key: K): BOOLEAN
		do
			if is_array_indexed then
				Result := content.valid_index (as_integer (key) - index_lower)
			else
				Result := Precursor (key)
			end
		end

feature -- Cursor movement

	start
			-- Bring cursor to first position.
		do
				-- Get lower bound of iteration if any.
			iteration_position := next_iteration_position (-1)
		end

	forth
			-- Advance cursor to next occupied position,
			-- or `off' if no such position remains.
		do
			iteration_position := next_iteration_position (iteration_position)
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

			unexported_fields := once "[
				hash_table_version_64, ht_lowest_deleted_position, ht_deleted_key, ht_deleted_item
			]"
			Eiffel.copy_fields (other, Current, unexported_fields)
		end

	next_iteration_index (a_position, i_upper: INTEGER; is_deleted: like deleted_marks): INTEGER
		-- Given an iteration position, advanced to the next one
		local
			i: INTEGER; break: BOOLEAN
		do
			if is_array_indexed then
				from i := a_position + 1 until i > i_upper or break loop
					if i = default_value_index or else content [i] /= computed_default_value then
						break := True
					else
						i := i + 1
					end
				end
				Result := i
			else
				Result := Precursor (a_position, i_upper, is_deleted)
			end
		end

	next_iteration_position (a_position: INTEGER): INTEGER
		-- Given an iteration position, advanced to the next one
		local
			i, i_upper: INTEGER; break: BOOLEAN
		do
			i_upper := content.count - 1
			from i := a_position + 1 until i > i_upper or break loop
				if i = default_value_index or else content [i] /= computed_default_value then
					break := True
				else
					i := i + 1
				end
			end
			Result := i
		end

	previous_iteration_position (a_position: INTEGER): INTEGER
		-- Given an iteration position, go to the previous one
		local
			i: INTEGER; break: BOOLEAN
		do
			from i := a_position - 1 until i < 0 or break loop
				if i = default_value_index or else content [i] /= computed_default_value then
					break := True
				else
					i := i - 1
				end
			end
			Result := i
		end

feature {EL_SPARSE_ARRAY_TABLE_ITERATION_CURSOR} -- Deferred

	as_integer (a_key: K): INTEGER
		deferred
		end

	index_to_key (index: INTEGER): K
		deferred
		end

feature {EL_SPARSE_ARRAY_TABLE_ITERATION_CURSOR} -- Internal attributes

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