note
	description: "Reflected makeable from string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 7:31:30 GMT (Monday 12th December 2022)"
	revision: "5"

class
	EL_REFLECTED_MAKEABLE_FROM_STRING_8

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING [STRING_8]]

create
	make

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached value (a_object) as v then
				v.make_from_general (readable.read_string_8)
			end
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		do
			if attached value (a_object) as v then
				writable.write_string_8 (v.to_string)
			end
		end
end