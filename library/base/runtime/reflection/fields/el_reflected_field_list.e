note
	description: "Array of reflected fields for a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-25 9:45:41 GMT (Saturday 25th April 2020)"
	revision: "11"

class
	EL_REFLECTED_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		rename
			make as make_for_range,
			make_from_array as make
		end

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
				i_th (i).write_crc (crc)
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
			create Result.make (count)
			from i := 1 until i > count loop
				l_item := i_th (i)
				Result.extend (l_item, l_item.name)
				i := i + 1
			end
		end

feature -- Basic operations

	reorder (tuple_list: ARRAY [TUPLE [index: INTEGER_32; offset: INTEGER_32]])
			-- reorder array by shifting each field with tuples (`i', `offset')
		require
			valid_shifts: across tuple_list as l_shift all
				valid_shift (l_shift.item.index, l_shift.item.offset)
			end
		local
			i, offset: INTEGER_32
		do
			across tuple_list as l_shift loop
				i := l_shift.item.index; offset := l_shift.item.offset
				if valid_shift (i, offset) then
					shift_i_th (i, offset)
				end
			end
		end

	sink_except (enclosing_object: EL_REFLECTIVE; sinkable: EL_DATA_SINKABLE; excluded: EL_FIELD_INDICES_SET)
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				if not excluded.has (i) then
					i_th (i).write (enclosing_object, sinkable)
				end
				i := i + 1
			end
		end

end
