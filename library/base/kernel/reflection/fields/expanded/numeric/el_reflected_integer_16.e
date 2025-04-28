note
	description: "Reflected ${INTEGER_16} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:21:11 GMT (Monday 28th April 2025)"
	revision: "29"

class
	EL_REFLECTED_INTEGER_16

inherit
	EL_REFLECTED_INTEGER_FIELD [INTEGER_16]
		rename
			abstract_type as Integer_16_type
		end

create
	make

feature -- Access

	value (object: ANY): INTEGER_16
		do
			Result := {ISE_RUNTIME}.integer_16_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

feature -- Measurement

	size_of (object: ANY): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Integer_16_bytes
		end

feature -- Conversion

	reference_value (object: ANY): INTEGER_16_REF
		do
			Result := value (object).to_reference
		end

	to_natural_64 (object: ANY): NATURAL_64
		do
			Result := value (object).to_natural_64
		end

feature -- Basic operations

	set (object: ANY; a_value: INTEGER_16)
		do
			{ISE_RUNTIME}.set_integer_16_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, a_value
			)
		end

	set_from_double (object: ANY; a_value: DOUBLE)
		do
			set (object, a_value.rounded.to_integer_16)
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		do
			set (object, a_value.to_integer_16)
		end

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		do
			set (object, a_value.to_integer_16)
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_integer_16)
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_integer_16 (value (object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING; a_value: INTEGER_16)
		do
			string.append_integer_16 (a_value)
		end

	append_directly (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_integer_16 (v)
			end
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER_16
		do
			Result := string.to_integer_16
		end

end