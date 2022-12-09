note
	description: "Reflected [$source NATURAL_16] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "21"

class
	EL_REFLECTED_NATURAL_16

inherit
	EL_REFLECTED_INTEGER_FIELD [NATURAL_16]
		rename
			field_value as natural_16_field
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): NATURAL_16_REF
		do
			Result := value (a_object).to_reference
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Natural_16_bytes
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: NATURAL_16)
		do
			enclosing_object := a_object
			set_natural_16_field (index, a_value)
		end

	set_from_double (a_object: EL_REFLECTIVE; a_value: DOUBLE)
		do
			set (a_object, a_value.rounded.to_natural_16)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_natural_16)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_natural_16)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_natural_16 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: NATURAL_16)
		do
			string.append_natural_16 (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_natural_16 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): NATURAL_16
		do
			Result := string.to_natural_16
		end

end