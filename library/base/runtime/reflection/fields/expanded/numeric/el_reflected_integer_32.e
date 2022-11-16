note
	description: "Reflected [$source INTEGER_32] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "22"

class
	EL_REFLECTED_INTEGER_32

inherit
	EL_REFLECTED_INTEGER_FIELD [INTEGER_32]
		rename
			field_value as integer_32_field
		redefine
			reset
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): INTEGER_32_REF
		do
			Result := value (a_object).to_reference
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Integer_32_bytes
		end

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

	set_from_double (a_object: EL_REFLECTIVE; a_value: DOUBLE)
		do
			set (a_object, a_value.rounded)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_integer_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_integer_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: INTEGER_32)
		do
			string.append_integer (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_integer_32 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER_32
		do
			Result := string.to_integer_32
		end

end