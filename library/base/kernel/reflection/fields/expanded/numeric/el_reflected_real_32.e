note
	description: "Reflected ${REAL_32} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 19:04:53 GMT (Saturday 22nd March 2025)"
	revision: "24"

class
	EL_REFLECTED_REAL_32

inherit
	EL_REFLECTED_NUMERIC_FIELD [REAL_32]
		rename
			abstract_type as Real_32_type
		end

create
	make

feature -- Access

	value (a_object: EL_REFLECTIVE): REAL_32
		do
			Result := {ISE_RUNTIME}.real_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0
			)
		end

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): REAL_32_REF
		do
			Result := value (a_object).to_reference
		end

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			Result := value (a_object).truncated_to_integer_64.to_natural_64
		end

feature -- Measurement

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Real_32_bytes
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: REAL_32)
		do
			{ISE_RUNTIME}.set_real_32_field (
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
			set (a_object, readable.read_real_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_real_32 (value (a_object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: REAL_32)
		do
			string.append_real (a_value)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_real_32 (v)
			end
		end

end