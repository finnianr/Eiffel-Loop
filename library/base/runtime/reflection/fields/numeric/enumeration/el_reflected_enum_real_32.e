note
	description: "REAL_32 field with enumerated values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 12:05:02 GMT (Monday 7th December 2020)"
	revision: "1"

class
	EL_REFLECTED_ENUM_REAL_32

inherit
	EL_REFLECTED_ENUMERATION [REAL_32]
		rename
			field_value as real_32_field
		undefine
			reset
		end

	EL_REFLECTED_REAL_32
		rename
			make as make_field
		undefine
			to_string, set_from_string, write_crc
		end

create
	make

feature {NONE} -- Implementation

	is_numeric (string: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := string.is_real_32
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: REAL_32)
		do
			crc.add_real_32 (enum_value)
		end

end