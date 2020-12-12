note
	description: "`NATURAL_8' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-11 13:20:14 GMT (Friday 11th December 2020)"
	revision: "9"

class
	EL_REFLECTED_NATURAL_8

inherit
	EL_REFLECTED_NUMERIC_FIELD [NATURAL_8]
		rename
			field_value as natural_8_field
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

	to_enumeration (a_enumeration: EL_ENUMERATION [NATURAL_8]): EL_REFLECTED_ENUM_NATURAL_8
		do
			create Result.make (Current, a_enumeration)
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: NATURAL_8)
		do
			enclosing_object := a_object
			set_natural_8_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_natural_8)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_natural_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_natural_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_8 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: NATURAL_8)
		do
			string.append_natural_8 (a_value)
		end

end