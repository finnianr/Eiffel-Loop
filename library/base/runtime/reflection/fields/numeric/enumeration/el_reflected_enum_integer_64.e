note
	description: "[
		[$source INTEGER_64] field with enumerated values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-04 10:25:14 GMT (Thursday 4th March 2021)"
	revision: "3"

class
	EL_REFLECTED_ENUM_INTEGER_64

inherit
	EL_REFLECTED_ENUMERATION [INTEGER_64]
		rename
			field_value as integer_64_field
		undefine
			reset
		end

	EL_REFLECTED_INTEGER_64
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
			Result := string.is_integer_64
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: INTEGER_64)
		do
			crc.add_integer_64 (enum_value)
		end

end