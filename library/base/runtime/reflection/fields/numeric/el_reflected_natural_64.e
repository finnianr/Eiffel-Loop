note
	description: "NATURAL_64 field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-03 12:24:58 GMT (Thursday 3rd May 2018)"
	revision: "4"

class
	EL_REFLECTED_NATURAL_64

inherit
	EL_REFLECTED_NUMERIC_FIELD [NATURAL_64]
		rename
			field_value as natural_64_field
		end

create
	make

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			enclosing_object := a_object
			set_natural_64_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVELY_SETTABLE; readable: EL_READABLE)
		do
			set (a_object, readable.read_natural_64)
		end

	set_from_integer (a_object: EL_REFLECTIVELY_SETTABLE; a_value: INTEGER)
		do
			set (a_object, a_value.to_natural_64)
		end

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, string.to_natural_64)
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: NATURAL_64)
		do
			string.append_natural_64 (a_value)
		end

end
