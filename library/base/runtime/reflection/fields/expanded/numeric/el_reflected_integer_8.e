note
	description: "Reflected [$source INTEGER_8] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 11:13:34 GMT (Saturday 16th October 2021)"
	revision: "18"

class
	EL_REFLECTED_INTEGER_8

inherit
	EL_REFLECTED_NUMERIC_FIELD [INTEGER_8]
		rename
			field_value as integer_8_field
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): INTEGER_8_REF
		do
			Result := value (a_object).to_reference
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: INTEGER_8)
		do
			enclosing_object := a_object
			set_integer_8_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_8)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_integer_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_8 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_8)
		do
			string.append_integer_8 (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_integer_8 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER_8
		do
			Result := string.to_integer_8
		end

end