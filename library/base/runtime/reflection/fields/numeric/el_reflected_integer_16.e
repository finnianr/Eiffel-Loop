note
	description: "INTEGER_16 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 11:23:33 GMT (Monday 7th December 2020)"
	revision: "7"

class
	EL_REFLECTED_INTEGER_16

inherit
	EL_REFLECTED_NUMERIC_FIELD [INTEGER_16]
		rename
			field_value as integer_16_field
		end

create
	make

feature -- Access

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Conversion

	to_enumeration (a_enumeration: EL_ENUMERATION [INTEGER_16]): EL_REFLECTED_ENUM_INTEGER_16
		do
			create Result.make (enclosing_object, index, name, a_enumeration)
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: INTEGER_16)
		do
			enclosing_object := a_object
			set_integer_16_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVELY_SETTABLE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_16)
		end

	set_from_integer (a_object: EL_REFLECTIVELY_SETTABLE; a_value: INTEGER)
		do
			set (a_object, a_value.to_integer_16)
		end

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_integer_16)
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_16 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_16)
		do
			string.append_integer_16 (a_value)
		end

end