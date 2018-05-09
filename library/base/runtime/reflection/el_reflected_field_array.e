note
	description: "Array of reflected fields for a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 10:31:33 GMT (Tuesday 24th April 2018)"
	revision: "2"

class
	EL_REFLECTED_FIELD_ARRAY

inherit
	ARRAY [EL_REFLECTED_FIELD]
		rename
			make as make_for_range,
			make_from_array as make
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		undefine
			is_equal, copy
		end

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
				item (i).write_crc (crc)
				i := i + 1
			end
			Result := crc.checksum
		end

	name_list: EL_STRING_LIST [STRING]
		local
			i: INTEGER
		do
			create Result.make (count)
			from i := 1 until i > count loop
				Result.extend (item (i).name)
				i := i + 1
			end
		end

feature -- Conversion

	to_table (enclosing_object: EL_REFLECTIVE): EL_REFLECTED_FIELD_TABLE
		local
			i: INTEGER; i_th: like item
		do
			create Result.make (count)
			from i := 1 until i > count loop
				i_th := item (i)
				Result.extend (i_th, i_th.name)
				i := i + 1
			end
		end

feature -- Basic operations

	sink_except (enclosing_object: EL_REFLECTIVE; sinkable: EL_DATA_SINKABLE; excluded: EL_FIELD_INDICES_SET)
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				if not excluded.has (i) then
					item (i).write (enclosing_object, sinkable)
				end
				i := i + 1
			end
		end

	reorder (tuple_list: ARRAY [TUPLE [i: INTEGER_32; offset: INTEGER_32]])
			-- reorder array by shifting each field with tuples (`i', `offset')
		local
			shift: PROCEDURE [INTEGER_32, INTEGER_32]
			list: EL_ARRAYED_LIST [like item]
		do
			create list.make_from_array (Current)
			shift := agent list.shift_i_th (?, ?)
			tuple_list.do_all (agent shift.call)
		end

end
