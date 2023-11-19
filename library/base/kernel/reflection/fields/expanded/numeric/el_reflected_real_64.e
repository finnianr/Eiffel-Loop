note
	description: "Reflected [$source REAL_64] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-18 21:58:12 GMT (Saturday 18th November 2023)"
	revision: "22"

class
	EL_REFLECTED_REAL_64

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_64]
		rename
			abstract_type as Real_64_type
		end

create
	make

feature -- Access

	value (a_object: EL_REFLECTIVE): DOUBLE
		do
			Result := {ISE_RUNTIME}.real_64_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0
			)
		end

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): REAL_64_REF
		do
			Result := value (a_object).to_reference
		end

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			Result := value (a_object).truncated_to_integer_64.as_natural_64
		end

feature -- Measurement

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Real_64_bytes
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_64)
		do
			{ISE_RUNTIME}.set_real_64_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0, a_value
			)
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
			set (a_object, readable.read_real_64)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_real_64 (value (a_object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: REAL_64)
		do
			string.append_double (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_real_64 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): REAL_64
		do
			Result := string.to_real_64
		end

end