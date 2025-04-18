note
	description: "Reflected ${NATURAL_8} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-24 11:12:28 GMT (Monday 24th March 2025)"
	revision: "28"

class
	EL_REFLECTED_NATURAL_8

inherit
	EL_REFLECTED_INTEGER_FIELD [NATURAL_8]
		rename
			abstract_type as Natural_8_type
		end

create
	make

feature -- Access

	value (a_object: EL_REFLECTIVE): NATURAL_8
		do
			Result := {ISE_RUNTIME}.natural_8_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0
			)
		end

feature -- Measurement

	size_of (a_object: EL_REFLECTIVE): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Natural_8_bytes
		end

feature -- Conversion

	reference_value (a_object: EL_REFLECTIVE): NATURAL_8_REF
		do
			Result := value (a_object).to_reference
		end

	to_natural_64 (a_object: EL_REFLECTIVE): NATURAL_64
		do
			Result := value (a_object).to_natural_64
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: NATURAL_8)
		do
			{ISE_RUNTIME}.set_natural_8_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($a_object, 0), 0, a_value
			)
		end

	set_from_double (a_object: EL_REFLECTIVE; a_value: DOUBLE)
		do
			set (a_object, a_value.rounded.to_natural_8)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_natural_8)
		end

	set_from_natural_64 (a_object: EL_REFLECTIVE; a_value: NATURAL_64)
		do
			set (a_object, a_value.to_natural_8)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_natural_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_natural_8 (value (a_object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: NATURAL_8)
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