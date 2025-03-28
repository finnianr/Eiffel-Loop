note
	description: "List of fields conforming to ${EL_REFLECTED_FIELD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 16:00:09 GMT (Friday 28th March 2025)"
	revision: "32"

class
	EL_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		rename
			make as make_list,
			readable as is_readable
		redefine
			initialize
		end

	EL_TYPE_UTILITIES
		rename
			as_structure as as_any_structure
		export
			{NONE} all
			{ANY} is_uniform_type
		undefine
			copy, is_equal
		end

	EL_REFLECTION_HANDLER

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32


create
	make, make_empty

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create table.make (capacity, foreign_naming)
		end

	make (meta_data: EL_CLASS_META_DATA)
		do
			if attached meta_data.field_info_table as info_table
				and then attached meta_data.target as target
				and then attached info_table.new_not_transient_subset (target.new_transient_fields) as field_names
			then
				foreign_naming := target.foreign_naming
				make_list (field_names.count)
				across field_names as list loop
					if attached list.item as name then
						if info_table.has_immutable_key (name)
							and then attached info_table.found_type_info as type_info
							and then target.field_included (type_info)
							and then attached meta_data.new_reflected_field (type_info, name) as new_field
						then
							extend (new_field)
							if attached foreign_naming as naming then
								new_field.set_export_name (naming.exported (new_field.name))
								naming.inform (new_field.name)
							end
						end
					end
				end
				set_order (target.new_field_sorter, info_table)
				fill_table (target.new_representations)
			else
				make_empty
			end
		ensure
			valid_list: is_valid
		end

feature -- Access

	field_hash: NATURAL
		-- CRC checksum for field names and field types
		local
			i: INTEGER
		do
			if attached crc_generator as crc and then attached area as field then
				from i := 0 until i = field.count loop
					field [i].write_field_hash (crc)
					i := i + 1
				end
				Result := crc.checksum
			end
		end

	field_with (object: EL_REFLECTIVE; value: ANY): detachable EL_REFLECTED_FIELD
		-- Reflected field in `object' for reference `value'. `Void' if not found.
		require
			is_reference_value: not value.generating_type.is_expanded
		local
			type_id, i: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (value)
			if attached area as l_area then
				from i := 0 until i = l_area.count or attached Result loop
					if attached l_area [i] as field and then not field.is_expanded
						and then field.type_id = type_id and then field.value (object) = value
					then
						Result := field
					end
					i := i + 1
				end
			end
		end

	field_with_address (object: EL_REFLECTIVE; field_address: POINTER): detachable EL_REFLECTED_FIELD
		-- Reflected field in `object' with field address equal to `field_address'.
		-- `Void' if not found.
		local
			i: INTEGER
		do
			if attached area as l_area then
				from i := 0 until i = l_area.count or attached Result loop
					if attached l_area [i] as field and then field.address (object) = field_address then
						Result := field
					end
					i := i + 1
				end
			end
		end

	indices_set: EL_FIELD_INDICES_SET
		local
			i: INTEGER
		do
			create Result.make_empty_area (count)
			if attached area as field then
				from i := 0 until i = field.count loop
					Result.extend (field [i].index)
					i := i + 1
				end
			end
		end

	name_list: EL_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_filled (count, agent i_th_name)
		end

	name_list_for (object: EL_REFLECTIVE; value_list: CONTAINER [ANY]): EL_IMMUTABLE_STRING_8_LIST
		-- list of field names in enclosing `object' corresponding to reference values
		-- of uniform type contained in `value_list'.
		require
			uniform_types: is_uniform_type (value_list)
		local
			i, type_first, value_count: INTEGER
		do
			if attached as_any_structure (value_list) as value_structure then
				value_count := value_structure.count
				create Result.make (value_count)
				if value_count > 0 and then attached area as l_area then
					type_first := {ISE_RUNTIME}.dynamic_type (value_structure.first)
					from i := 0 until i = l_area.count loop
						if attached l_area [i] as field and then field.type_id = type_first
							and then value_list.has (field.value (object))
						then
							Result.extend (field.name)
						end
						i := i + 1
					end
				end
			else
				create Result.make_empty
			end
		end

	query_by_type (type: TYPE [EL_REFLECTED_FIELD]): EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		-- list of reflected fields of `type'
		local
			type_id, i: INTEGER
		do
			if attached {like query_by_type} Arrayed_list_factory.new_list (type, count) as new
				and then attached area as l_area
			then
				Result := new
				type_id := type.type_id
				from i := 0 until i = l_area.count loop
					if attached l_area [i] as field and then {ISE_RUNTIME}.dynamic_type (field) = type_id then
						Result.extend (field)
					end
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

	special_subset (excluded_set: EL_FIELD_INDICES_SET): SPECIAL [EL_REFLECTED_FIELD]
		local
			field_list: ARRAYED_LIST [like item]; i: INTEGER
		do
			if excluded_set.count = 0 then
				Result := area

			elseif attached area as l_area then
				create field_list.make (count - excluded_set.count)
				from i := 0 until i = l_area.count loop
					if attached l_area [i] as field and then not excluded_set.has (field.index) then
						field_list.extend (field)
					end
					i := i + 1
				end
				field_list.trim
				Result := field_list.area
			else
				create Result.make_empty (0)
			end
		end

	table: EL_FIELD_TABLE
		-- field table looked up by `item.name'

	type_set: like type_table.item_list
		-- set of types use in table
		do
			Result := type_table.item_list
		end

	type_table: EL_HASH_TABLE [TYPE [ANY], INTEGER]
		local
			i: INTEGER
		do
			create Result.make_equal (count)
			if attached area as l_area then
				from i := 0 until i = l_area.count loop
					if attached l_area [i] as field then
						Result.put (field.type, field.type_id)
					end
					i := i + 1
				end
			end
		end

	value_list_for_type (object: EL_REFLECTIVE; field_type: TYPE [ANY]): EL_ARRAYED_LIST [ANY]
		-- list of field values in `object' for fields with type `field_type'
		local
			type_id, i: INTEGER
		do
			if attached Arrayed_list_factory.new_list (field_type, count) as new
				and then attached area as l_area
			then
				Result := new
				type_id := field_type.type_id
				from i := 0 until i = l_area.count loop
					if attached l_area [i] as field and then field.type_id = type_id then
						if field.is_expanded then
							Result.extend (field.value (object))

						elseif attached field.value (object) as value then
							Result.extend (value)
						end
					end
					i := i + 1
				end
			else
				create Result.make_empty
			end
		end

feature -- Status query

	has_default_strings (object: EL_REFLECTIVE): BOOLEAN
		-- `True' if all string fields in `object' are empty
		local
			i: INTEGER
		do
			Result := True
			if attached area as l_area then
				from i := 0 until i = l_area.count or not Result loop
					if attached l_area [i] as field and then field.is_string_type
						and then attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field
					then
						Result := string_field.value (object).is_empty
					end
					i := i + 1
				end
			end
		end

feature -- Comparison

	all_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		-- `True' if all fields in `a_current' and `other' are equal
		local
			i: INTEGER
		do
			Result := True
			if attached area as field then
				from i := 0 until i = field.count or not Result loop
					Result := field [i].are_equal (a_current, other)
					i := i + 1
				end
			end
		end

	same_fields (a_current, other: EL_REFLECTIVE; field_set: EL_FIELD_INDICES_SET): BOOLEAN
		-- `True' if all fields with `field.index' in `field_set' have same value
		-- for `a_current' and `other' enclosing objects
		local
			i: INTEGER
		do
			Result := True
			if attached area as l_area then
				from i := 0 until i = l_area.count or not Result loop
					if attached l_area [i] as field and then field_set.has (field.index) then
						Result := field.are_equal (a_current, other)
					end
					i := i + 1
				end
			end
		end

feature -- Contract Support

	is_valid: BOOLEAN
		-- `True' if `table' has same count as `Current' and items are in same order
		do
			if table.count = count then
				Result := across table as field all
					field.key = i_th (field.cursor_index).name
				end
			end
		end

feature -- Basic operations

	set_all_from_readable (target: EL_REFLECTIVE; readable: EL_READABLE)
		local
			i: INTEGER
		do
			if attached area as field then
				from i := 0 until i = field.count loop
					field [i].set_from_readable (target, readable)
					i := i + 1
				end
			end
		end

	sink (target: EL_REFLECTIVE; sinkable: EL_DATA_SINKABLE)
		local
			i: INTEGER
		do
			if attached area as field then
				from i := 0 until i = field.count loop
					field [i].write (target, sinkable)
					i := i + 1
				end
			end
		end

	write (target: EL_REFLECTIVE; a_writable: EL_WRITABLE)
		local
			i: INTEGER_32
		do
			if attached area as field then
				from i := 0 until i = field.count loop
					field [i].write (target, a_writable)
					i := i + 1
				end
			end
		end

	write_to_memory (target: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		local
			i: INTEGER_32
		do
			if attached area as field then
				from i := 0 until i = field.count loop
					field [i].write_to_memory (target, memory)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	fill_table (representation_table: EL_HASH_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY], STRING])
		-- fill `table' and set field representations to make `Current.is_valid' equal to `True'
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				if attached i_th (i) as field then
					table.extend (field, field.name)
					if representation_table.has_key (field.name) then
						field.set_representation (representation_table.found_item)
					end
				end
				i := i + 1
			end
		end

	i_th_name (i: INTEGER): IMMUTABLE_STRING_8
		do
			Result := i_th (i).name
		end

	set_order (order: EL_FIELD_LIST_ORDER; field_info_table: EL_OBJECT_FIELDS_TABLE)
		require
			table_not_filled: table.count = 0
		local
			i, offset, i_final: INTEGER; l_indices_set: EL_FIELD_INDICES_SET
		do
		-- apply `name_sort' sort if attached
			if attached order.name_sort as name_sort then
				order_by (name_sort, True)
			end
		-- apply field order shifts if not default
			if order.field_shifts.count > 0 then
				across order.field_shifts as list loop
					i := list.item.index; offset := list.item.offset
					if valid_shift (i, offset) then
						shift_i_th (i, offset)
					end
				end
			end
		-- move any explicitly ordered fields to the end of list
			if order.reordered_fields.count > 0 then
				create l_indices_set.make (field_info_table, order.reordered_fields)
				i_final := l_indices_set.count
				from i := 0 until i = i_final loop
					find_first_equal (l_indices_set [i], agent {EL_REFLECTED_FIELD}.index)
					if found then
						shift (count - index)
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Internal attributes

	foreign_naming: detachable EL_NAME_TRANSLATER

end