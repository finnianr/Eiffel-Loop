note
	description: "Reflected ${NATURAL_32} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:20:23 GMT (Monday 28th April 2025)"
	revision: "29"

class
	EL_REFLECTED_NATURAL_32

inherit
	EL_REFLECTED_INTEGER_FIELD [NATURAL_32]
		rename
			abstract_type as Natural_32_type
		end

create
	make

feature -- Access

	value (object: ANY): NATURAL_32
		do
			Result := {ISE_RUNTIME}.natural_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

feature -- Measurement

	size_of (object: ANY): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Natural_32_bytes
		end

feature -- Conversion

	reference_value (object: ANY): NATURAL_32_REF
		do
			Result := value (object).to_reference
		end

	to_natural_64 (object: ANY): NATURAL_64
		do
			Result := value (object).to_natural_64
		end

feature -- Basic operations

	set (object: ANY; a_value: NATURAL_32)
		do
			{ISE_RUNTIME}.set_natural_32_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, a_value
			)
		end

	set_from_double (object: ANY; a_value: DOUBLE)
		local
			integer: INTEGER
		do
			if a_value < integer.Max_value then
				set (object, a_value.rounded.to_natural_32)
			else
				set (object, a_value.truncated_to_integer_64.to_natural_32)
			end
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		do
			set (object, a_value.to_natural_32)
		end

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		do
			set (object, a_value.to_natural_32)
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_natural_32)
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_natural_32 (value (object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: NATURAL_32)
		do
			string.append_natural_32 (a_value)
		end

	append_directly (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_natural_32 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): NATURAL_32
		do
			Result := string.to_natural_32
		end

end