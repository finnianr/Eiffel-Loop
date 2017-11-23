note
	description: "Summary description for {EL_UUID}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_UUID

inherit
	UUID
		undefine
			is_equal
		end

	EL_STORABLE
		rename
			read_version as read_default_version
		undefine
			out
		redefine
			adjust_field_order
		end

create
	make_default, make, make_from_string, make_from_array

feature {NONE} -- Implementation

	adjust_field_order (fields: ARRAY [INTEGER])
		-- change order to: data_1, data_2 etc
		do
			do_swaps (fields, << [1, 4], [2, 4], [3, 4] >>)
		end

feature -- Constants

	Byte_count: INTEGER
		once
			Result := (32 + 16 * 3 + 64) // 8
		end

	Field_hash_checksum: NATURAL = 3515774772

end
