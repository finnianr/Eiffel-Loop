note
	description: "Reflected field for object conforming to ${EL_MAKEABLE_FROM_STRING [STRING_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:25:02 GMT (Monday 28th April 2025)"
	revision: "7"

class
	EL_REFLECTED_MAKEABLE_FROM_STRING_8

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING [STRING_8]]

create
	make

feature -- Basic operations

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			if attached value (object) as v then
				v.make_from_general (readable.read_string_8)
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		do
			if attached value (object) as v then
				writable.write_string_8 (v.to_string)
			end
		end
end