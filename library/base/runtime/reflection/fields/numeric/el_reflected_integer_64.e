note
	description: "`INTEGER_64' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-11 13:19:54 GMT (Friday 11th December 2020)"
	revision: "8"

class
	EL_REFLECTED_INTEGER_64

inherit
	EL_REFLECTED_NUMERIC_FIELD [INTEGER_64]
		rename
			field_value as integer_64_field
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

	to_enumeration (a_enumeration: EL_ENUMERATION [INTEGER_64]): EL_REFLECTED_ENUM_INTEGER_64
		do
			create Result.make (Current, a_enumeration)
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: INTEGER_64)
		do
			enclosing_object := a_object
			set_integer_64_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_64)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_integer_64)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_integer_64)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_64)
		do
			string.append_integer_64 (a_value)
		end

end