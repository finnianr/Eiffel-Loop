note
	description: "Reflected field for object conforming to ${EL_MAKEABLE_FROM_STRING [STRING_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-17 8:17:45 GMT (Friday 17th May 2024)"
	revision: "7"

class
	EL_REFLECTED_MAKEABLE_FROM_STRING_32

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING [STRING_32]]

create
	make

feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			if attached value (a_object) as v then
				v.make_from_general (readable.read_string_32)
			end
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		do
			if attached value (a_object) as v then
				writable.write_string_32 (v.to_string)
			end
		end
end