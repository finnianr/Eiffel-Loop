note
	description: "Reflected makeable from zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 17:30:27 GMT (Wednesday 29th January 2020)"
	revision: "3"

class
	EL_REFLECTED_MAKEABLE_FROM_ZSTRING

inherit
	EL_REFLECTED_MAKEABLE_FROM_STRING [EL_MAKEABLE_FROM_STRING [ZSTRING]]

create
	make
feature -- Basic operations

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			value (a_object).make_from_general (readable.read_string)
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITEABLE)
		do
			writable.write_string (value (a_object).to_string)
		end

end
