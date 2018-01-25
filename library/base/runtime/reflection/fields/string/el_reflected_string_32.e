note
	description: "Summary description for {EL_ZSTRING_SETTABLE_REFERENCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 15:43:58 GMT (Wednesday 17th January 2018)"
	revision: "4"

class
	EL_REFLECTED_STRING_32

inherit
	EL_REFLECTED_STRING
		redefine
			set_from_string, set_from_readable, to_string, write, default_value
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING_32
		do
			Result := value (a_object)
		end

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_string_32)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_32 (value (a_object))
		end

feature {NONE} -- Implementation

	set_default
		do
			default_value := Empty_string_32
		end

feature {NONE} -- Internal attributes

	default_value: STRING_32

end
