note
	description: "Array of reflected fields for a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 16:18:07 GMT (Sunday 16th July 2023)"
	revision: "23"

class
	EL_REFLECTED_FIELD_LIST

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

	name_list: like string_8_list
		do
			Result := string_8_list (agent {EL_REFLECTED_FIELD}.name)
		end

feature -- Conversion

	to_table (enclosing_object: EL_REFLECTIVE): EL_REFLECTED_FIELD_TABLE
		local
			i: INTEGER; l_item: like item
		do
			create Result.make (count, enclosing_object.foreign_naming)
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

	set_order (meta_data: EL_CLASS_META_DATA)
		-- reorder fields according to class `meta_data'
		local
			i, offset, i_final: INTEGER; indices_set: EL_FIELD_INDICES_SET
			enclosing_object: EL_REFLECTIVE_FIELD_ORDER
		do
			enclosing_object := meta_data.enclosing_object
			-- apply `field_order' sort if not default
			if not enclosing_object.has_default_field_order then
				order_by (enclosing_object.field_order, True)
			end
			-- apply field order shifts if not default
			if not enclosing_object.has_default_field_shifts then
				across enclosing_object.field_shifts as list loop
					i := list.item.index; offset := list.item.offset
					if valid_shift (i, offset) then
						shift_i_th (i, offset)
					end
				end
			end
			-- move any explicitly ordered fields to the end of list
			if not enclosing_object.has_default_reordered_fields then
				create indices_set.make (meta_data, enclosing_object.reordered_fields)
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

	sink (sinkable: EL_DATA_SINKABLE; enclosing_object: EL_REFLECTIVE)
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				i_th (i).write (enclosing_object, sinkable)
				i := i + 1
			end
		end

	write (enclosing_object: EL_REFLECTIVE; a_writable: EL_WRITABLE)
		local
			i, i_final: INTEGER_32
		do
			if attached area as l_area then
				i_final := count
				from i := 0 until i = i_final loop
					l_area [i].write (enclosing_object, a_writable)
					i := i + 1
				end
			end
		end

	write_to_memory (enclosing_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		local
			i, i_final: INTEGER_32
		do
			if attached area as l_area then
				i_final := count
				from i := 0 until i = i_final loop
					l_area [i].write_to_memory (enclosing_object, memory)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	new_exported_name (field: EL_REFLECTED_FIELD; translater: EL_NAME_TRANSLATER): STRING
		do
			Result := translater.exported (field.name)
		end

end