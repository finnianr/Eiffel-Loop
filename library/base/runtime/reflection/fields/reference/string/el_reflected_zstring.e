note
	description: "Reflected zstring"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 9:24:39 GMT (Tuesday 11th June 2019)"
	revision: "1"

class
	EL_REFLECTED_ZSTRING

inherit
	EL_REFLECTED_STRING_GENERAL [ZSTRING]

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {ZSTRING} string as zstring then
				set (a_object, zstring)
			else
				l_value.wipe_out
				l_value.append_string_general (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string (value (a_object))
		end
end
