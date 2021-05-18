note
	description: "Reflected [$source INTEGER_64] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-18 14:57:33 GMT (Tuesday 18th May 2021)"
	revision: "15"

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

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_64)
		do
			string.append_integer_64 (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_integer_64 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER_64
		do
			Result := string.to_integer_64
		end

end