note
	description: "[
		[$source INTEGER_16] field with enumerated values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:24:22 GMT (Monday 3rd May 2021)"
	revision: "4"

class
	EL_REFLECTED_ENUM_INTEGER_16

inherit
	EL_REFLECTED_ENUMERATION [INTEGER_16]
		rename
			field_value as integer_16_field
		end

	EL_REFLECTED_INTEGER_16
		rename
			make as make_field
		undefine
			append_to_string, to_string, set_from_string, write_crc
		end

create
	make

feature {NONE} -- Implementation

	is_numeric (string: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := string.is_integer_16
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: INTEGER_16)
		do
			crc.add_integer_16 (enum_value)
		end

end