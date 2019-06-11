note
	description: "Reflected makeable from string 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 10:44:02 GMT (Tuesday 11th June 2019)"
	revision: "1"

class
	EL_REFLECTED_MAKEABLE_FROM_STRING_32

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING_32]
		rename
			makeable_from_string_type_id as Makeable_from_string_32_type
		end

create
	make

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			value (a_object).make_from_general (readable.read_string_32)
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITEABLE)
		do
			writable.write_string_32 (value (a_object).to_string)
		end
end
