note
	description: "List of fields conforming to [$source EL_REFLECTED_FIELD]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 11:19:42 GMT (Monday 14th August 2023)"
	revision: "26"

class
	EL_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]

	EL_REFLECTION_HANDLER

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature -- Access

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