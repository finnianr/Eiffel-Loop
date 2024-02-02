note
	description: "Reflected field for object conforming to ${EL_MAKEABLE_FROM_STRING [STRING_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-02 11:01:01 GMT (Friday 2nd February 2024)"
	revision: "6"

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