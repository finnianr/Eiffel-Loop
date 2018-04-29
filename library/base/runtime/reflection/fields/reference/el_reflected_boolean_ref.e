note
	description: "Summary description for {EL_REFLECTED_BOOLEAN_REF}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-25 16:15:27 GMT (Wednesday 25th April 2018)"
	revision: "3"

class
	EL_REFLECTED_BOOLEAN_REF

inherit
	EL_REFLECTED_REFERENCE
		redefine
			default_value, set_from_readable, set_from_string,  write
		end

create
	make

feature -- Element change

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			value (a_object).set_item (a_value.read_boolean)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			value (a_object).set_from_string (string.to_string_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_boolean (value (a_object).item)
		end

feature {NONE} -- Internal attributes

	default_value: EL_BOOLEAN_REF

end
