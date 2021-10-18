note
	description: "Reflected [$source NATURAL_8] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-17 12:57:59 GMT (Sunday 17th October 2021)"
	revision: "19"

class
	EL_REFLECTED_NATURAL_8

inherit
	EL_REFLECTED_NUMERIC_FIELD [NATURAL_8]
		rename
			field_value as natural_8_field
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): NATURAL_8_REF
		do
			Result := value (a_object).to_reference
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Natural_8_bytes
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

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_8 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: NATURAL_8)
		do
			string.append_natural_8 (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_natural_8 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): NATURAL_8
		do
			Result := string.to_natural_8
		end

end