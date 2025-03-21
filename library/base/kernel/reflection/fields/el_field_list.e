note
	description: "List of fields conforming to ${EL_REFLECTED_FIELD}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-21 10:49:31 GMT (Friday 21st March 2025)"
	revision: "28"

class
	EL_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]

	EL_REFLECTION_HANDLER

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature -- Access

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

	field_hash: NATURAL
		-- CRC checksum for field names and field types
		local
			crc: like crc_generator; i: INTEGER
		do
			crc := crc_generator
			from i := 1 until i > count loop
				i_th (i).write_field_hash (crc)
				i := i + 1
			end
			Result := crc.checksum
		end

	name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			create Result.make_filled (count, agent i_th_name)
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

feature -- Conversion

	to_table (target: EL_REFLECTIVE): EL_FIELD_TABLE
		local
			i: INTEGER; l_item: like item
		do
			create Result.make (count, target.foreign_naming)
			from i := 1 until i > count loop
				l_item := i_th (i)
				Result.extend (l_item, l_item.name)
				i := i + 1
			end
		end

feature -- Basic operations

	set_export_names (translater: EL_NAME_TRANSLATER)
		local
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
		-- Join exported names into one comma-separated `IMMUTABLE_STRING_8'
			create list.make (string_8_list (agent new_exported_name (?, translater)).joined (',') , ',')
			from list.start until list.after loop
				i_th (list.index).set_export_name (list.item)
				list.forth
			end
		end

	set_order (order: EL_FIELD_LIST_ORDER; field_info_table: EL_OBJECT_FIELDS_TABLE)
		local
			i, offset, i_final: INTEGER; indices_set: EL_FIELD_INDICES_SET
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
				create indices_set.make (field_info_table, order.reordered_fields)
				i_final := indices_set.count
				from i := 0 until i = i_final loop
					find_first_equal (indices_set [i], agent {EL_REFLECTED_FIELD}.index)
					if found then
						shift (count - index)
					end
					i := i + 1
				end
			end
		end

	sink (sinkable: EL_DATA_SINKABLE; target: EL_REFLECTIVE)
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				i_th (i).write (target, sinkable)
				i := i + 1
			end
		end

	write (target: EL_REFLECTIVE; a_writable: EL_WRITABLE)
		local
			i, i_final: INTEGER_32
		do
			if attached area as l_area then
				i_final := count
				from i := 0 until i = i_final loop
					l_area [i].write (target, a_writable)
					i := i + 1
				end
			end
		end

	write_to_memory (target: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		local
			i, i_final: INTEGER_32
		do
			if attached area as l_area then
				i_final := count
				from i := 0 until i = i_final loop
					l_area [i].write_to_memory (target, memory)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	i_th_name (i: INTEGER): IMMUTABLE_STRING_8
		do
			Result := i_th (i).name
		end

	new_exported_name (field: EL_REFLECTED_FIELD; translater: EL_NAME_TRANSLATER): STRING
		do
			Result := translater.exported (field.name)
		end

end