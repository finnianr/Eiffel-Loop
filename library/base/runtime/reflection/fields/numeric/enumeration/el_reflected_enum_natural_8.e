note
	description: "NATURAL_8 field with enumerated values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 12:04:41 GMT (Monday 7th December 2020)"
	revision: "1"

class
	EL_REFLECTED_ENUM_NATURAL_8

inherit
	EL_REFLECTED_ENUMERATION [NATURAL_8]
		rename
			field_value as natural_8_field
		end

	EL_REFLECTED_NATURAL_8
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
			Result := string.is_natural_8
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: NATURAL_8)
		do
			crc.add_natural_8 (enum_value)
		end

end