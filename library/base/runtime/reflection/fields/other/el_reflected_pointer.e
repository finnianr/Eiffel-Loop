note
	description: "Summary description for {EL_REFLECTED_INTEGER_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 18:26:49 GMT (Wednesday 17th January 2018)"
	revision: "3"

class
	EL_REFLECTED_POINTER

inherit
	EL_REFLECTED_EXPANDED_FIELD [POINTER]
		rename
			field_value as pointer_field
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING
		do
			Result := value (a_object).out
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: POINTER)
		do
			enclosing_object := a_object
			set_pointer_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVELY_SETTABLE; readable: EL_READABLE)
		do
			set (a_object, readable.read_pointer)
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_WRITEABLE)
		do
			writeable.write_pointer (value (a_object))
		end

feature {NONE} -- Unimplemented

	set_from_integer (a_object: EL_REFLECTIVELY_SETTABLE; a_value: INTEGER)
		do
		end

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
		end

end
