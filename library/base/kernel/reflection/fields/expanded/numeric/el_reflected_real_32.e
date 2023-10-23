note
	description: "Reflected [$source REAL_32] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-23 14:29:45 GMT (Monday 23rd October 2023)"
	revision: "20"

class
	EL_REFLECTED_REAL_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_32]
		rename
			field_value as real_32_field
		end

create
	make

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): REAL_32_REF
		do
			Result := value (a_object).to_reference
		end

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Real_32_bytes
		end

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			Result := value (a_object).truncated_to_integer_64.to_natural_64
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_32)
		do
			enclosing_object := a_object
			set_real_32_field (index, a_value)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value)
		end

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			set (a_object, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_real_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_real_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING; a_value: REAL_32)
		do
			string.append_real (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_real_32 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): REAL_32
		do
			Result := string.to_real_32
		end

end