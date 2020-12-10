note
	description: "Array of reflected fields for a class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-10 11:13:38 GMT (Thursday 10th December 2020)"
	revision: "12"

class
	EL_REFLECTED_FIELD_LIST

inherit
	EL_ARRAYED_LIST [EL_REFLECTED_FIELD]

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