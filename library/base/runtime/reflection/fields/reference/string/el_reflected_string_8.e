note
	description: "Reflected string 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 9:24:34 GMT (Tuesday 11th June 2019)"
	revision: "1"

class
	EL_REFLECTED_STRING_8

inherit
	EL_REFLECTED_STRING_GENERAL [STRING_8]

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			if attached {STRING_8} string as string_8 then
				set (a_object, string_8)
			else
				l_value.wipe_out
				if attached {ZSTRING} string as zstr then
					zstr.append_to_string_8 (l_value)
				else
					l_value.append_string_general (string)
				end
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_8 (value (a_object))
		end
end
