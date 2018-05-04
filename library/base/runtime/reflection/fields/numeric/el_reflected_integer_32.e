note
	description: "INTEGER_32 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-17 18:21:47 GMT (Wednesday 17th January 2018)"
	revision: "3"

class
	EL_REFLECTED_INTEGER_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [INTEGER_32]
		rename
			field_value as integer_32_field
		redefine
			reset
		end

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			set (a_object, 0)
		end

	set (a_object: EL_REFLECTIVE; a_value: INTEGER_32)
		do
			enclosing_object := a_object
			set_integer_32_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVELY_SETTABLE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVELY_SETTABLE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_32)
		end

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_integer_32)
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_32)
		do
			string.append_integer (a_value)
		end

end
