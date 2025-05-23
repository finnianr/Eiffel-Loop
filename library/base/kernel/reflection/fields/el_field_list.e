note
	description: "List of fields conforming to ${EL_REFLECTED_FIELD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:44:35 GMT (Monday 5th May 2025)"
	revision: "38"

class
	EL_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		rename
			make as make_list,
			readable as is_readable
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

	EL_REFLECTED_REFERENCE_FACTORY
		export
			{NONE} all
		end

	EL_REFLECTION_HANDLER

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make, make_empty, make_abstract

feature {NONE} -- Initialization

	make (meta_data: EL_CLASS_META_DATA)
		local
			exported_csv_string: EL_CSV_STRING_8
		do
			if attached meta_data.field_info_table as info_table
				and then attached meta_data.target as target
				and then attached info_table.new_not_transient_subset (target.new_transient_fields) as field_names
				and then attached target.new_representations as representation_table
			then
				foreign_naming := target.foreign_naming
				make_list (field_names.count)
				create exported_csv_string.make (field_names.count * 20)
				across field_names as list loop
					if attached list.item as name then
						if info_table.has_immutable_key (name)
							and then attached info_table.found_type_info as type_info
							and then target.field_included (type_info)
							and then attached meta_data.new_reflected_field (type_info, name) as new_field
						then
							extend (new_field)
							if representation_table.has_key (new_field.name) then
								new_field.set_representation (representation_table.found_item)
							end
							if attached target.foreign_naming as naming then
								exported_csv_string.extend (naming.exported (new_field.name))
								naming.put (new_field.name)
							end
						end
					end
				end
				if exported_csv_string.count > 0
					and then attached exported_csv_string.to_immutable_list as immutable_list
				then
					across immutable_list as list loop
						i_th (list.cursor_index).set_export_name (list.item)
					end
				end
				set_order (target.new_field_sorter, info_table)
			else
				make_empty
			end
		end

	make_abstract (object: ANY; a_abstract_type: INTEGER; exclude_transient: BOOLEAN)
		-- make list of all fields in `object' matching `a_abstract_type' and exclude transient fields
		-- if `exclude_transient' is true
		local
			field_index: INTEGER
		do
			if attached Eiffel.reflected (object) as reflected_object
				and then attached reflected_object.new_field_type_set (a_abstract_type) as field_type_set
			then
				make_list (field_type_set.count)
				across field_type_set.new_name_list (reflected_object) as name loop
					field_index := field_type_set [name.cursor_index - 1]
					if exclude_transient implies not reflected_object.is_field_transient (field_index) then
						extend_for_type (object, field_index, a_abstract_type, name.item)
					end
				end
			else
				make_empty
			end
		end

feature -- Access

	export_table: EL_EXPORT_FIELD_TABLE
		-- lookup field `item' by `foreign_naming.imported'
		do
			if attached internal_export_table as internal then
				Result := internal
			else
				create Result.make (table, foreign_naming)
				internal_export_table := Result
			end
		end

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

	field_with (object: ANY; value: ANY): detachable EL_REFLECTED_FIELD
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

	field_with_address (object: ANY; field_address: POINTER): detachable EL_REFLECTED_FIELD
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

	name_list_for (object: ANY; value_list: CONTAINER [ANY]): EL_IMMUTABLE_STRING_8_LIST
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
		-- lookup field `item' by `item.name'
		local
			i: INTEGER
		do
			if attached internal_table as internal then
				Result := internal
			else
				create Result.make (count)
				from i := 1 until i > count loop
					if attached i_th (i) as field then
						Result.extend (field, field.name)
					end
					i := i + 1
				end

				internal_table := Result
			end
		end

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

	value_list_for_type (object: ANY; field_type: TYPE [ANY]): EL_ARRAYED_LIST [ANY]
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

	has_default_strings (object: ANY): BOOLEAN
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

	extend_for_type (object: ANY; a_index, a_type: INTEGER; a_name: IMMUTABLE_STRING_8)
		local
			field: EL_REFLECTED_FIELD; type_properties: EL_FIELD_TYPE_PROPERTIES
		do
			inspect a_type
				when Integer_8_type then
					create {EL_REFLECTED_INTEGER_8} field.make (object, a_index, a_name)

				when Integer_16_type then
					create {EL_REFLECTED_INTEGER_16} field.make (object, a_index, a_name)

				when Integer_32_type then
					create {EL_REFLECTED_INTEGER_32} field.make (object, a_index, a_name)

				when Integer_64_type then
					create {EL_REFLECTED_INTEGER_64} field.make (object, a_index, a_name)

				when Natural_8_type then
					create {EL_REFLECTED_NATURAL_8} field.make (object, a_index, a_name)

				when Natural_16_type then
					create {EL_REFLECTED_NATURAL_16} field.make (object, a_index, a_name)

				when Natural_32_type then
					create {EL_REFLECTED_NATURAL_32} field.make (object, a_index, a_name)

				when Natural_64_type then
					create {EL_REFLECTED_NATURAL_64} field.make (object, a_index, a_name)

				when Real_32_type then
					create {EL_REFLECTED_REAL_32} field.make (object, a_index, a_name)
					
				when Real_64_type then
					create {EL_REFLECTED_REAL_64} field.make (object, a_index, a_name)

				when Boolean_type then
					create {EL_REFLECTED_BOOLEAN} field.make (object, a_index, a_name)

				when Character_8_type then
					create {EL_REFLECTED_CHARACTER_8} field.make (object, a_index, a_name)

				when Character_32_type then
					create {EL_REFLECTED_CHARACTER_32} field.make (object, a_index, a_name)

				when Reference_type then
					create type_properties.make (a_index, dynamic_type (object))
					field := new_reference_field (object, type_properties, a_name)
			else
			end
			extend (field)
		end

	i_th_name (i: INTEGER): IMMUTABLE_STRING_8
		do
			Result := i_th (i).name
		end

	set_order (order: EL_FIELD_LIST_ORDER; field_info_table: EL_OBJECT_FIELDS_TABLE)
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

	internal_table: detachable EL_FIELD_TABLE

	internal_export_table: detachable EL_EXPORT_FIELD_TABLE

end