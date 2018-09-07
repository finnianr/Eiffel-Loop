note
	description: "REAL_32 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-03 12:25:23 GMT (Thursday 3rd May 2018)"
	revision: "4"

class
	EL_REFLECTED_REAL_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_32]
		rename
			field_value as real_32_field
		end

create
	make

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_32)
		do
			enclosing_object := a_object
			set_real_32_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVELY_SETTABLE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_real_32)
		end

	set_from_readable (a_object: EL_REFLECTIVELY_SETTABLE; readable: EL_READABLE)
		do
			set (a_object, readable.read_real_32)
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_WRITEABLE)
		do
			writeable.write_real_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: REAL_32)
		do
			string.append_real (a_value)
		end

end