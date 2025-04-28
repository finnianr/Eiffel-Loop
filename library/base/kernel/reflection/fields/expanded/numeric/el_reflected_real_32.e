note
	description: "Reflected ${REAL_32} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:19:29 GMT (Monday 28th April 2025)"
	revision: "26"

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

	value (object: ANY): REAL_32
		do
			Result := {ISE_RUNTIME}.real_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

feature -- Conversion

	reference_value (object: ANY): REAL_32_REF
		do
			Result := value (object).to_reference
		end

	to_natural_64 (object: ANY): NATURAL_64
		do
			Result := value (object).truncated_to_integer_64.to_natural_64
		end

feature -- Measurement

	size_of (object: ANY): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Real_32_bytes
		end

feature -- Basic operations

	set (object: ANY; a_value: REAL_32)
		do
			{ISE_RUNTIME}.set_real_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, a_value
			)
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		do
			set (object, a_value)
		end

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		do
			set (object, a_value)
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_real_32)
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_real_32 (value (object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: REAL_32)
		do
			string.append_real (a_value)
		end

	append_directly (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_real_32 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): REAL_32
		do
			Result := string.to_real_32
		end

end