note
	description: "Reflected ${CHARACTER_8} field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:18:43 GMT (Monday 28th April 2025)"
	revision: "28"

class
	EL_REFLECTED_CHARACTER_8

inherit
	EL_REFLECTED_EXPANDED_FIELD [CHARACTER_8]
		rename
			abstract_type as Character_8_type
		end

create
	make

feature -- Access

	reference_value (object: ANY): like value.to_reference
		do
			create Result
			Result.set_item (value (object))
		end

	value (object: ANY): CHARACTER_8
		do
			Result := {ISE_RUNTIME}.character_8_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0
			)
		end

feature -- Measurement

	size_of (object: ANY): INTEGER
		-- size of field object
		do
			Result := {PLATFORM}.Character_8_bytes
		end

feature -- Conversion

	to_natural_64 (object: ANY): NATURAL_64
		do
			Result := value (object).natural_32_code.to_natural_64
		end

feature -- Basic operations

	set (object: ANY; a_value: CHARACTER_8)
		do
			{ISE_RUNTIME}.set_character_8_field (
				index, {ISE_RUNTIME}.raw_reference_field_at_offset ($object, 0), 0, a_value
			)
		end

	set_from_readable (object: ANY; a_value: EL_READABLE)
		do
			set (object, a_value.read_character_8)
		end

	set_from_integer (object: ANY; a_value: INTEGER)
		do
			set (object, a_value.to_character_8)
		end

	set_from_natural_64 (object: ANY; a_value: NATURAL_64)
		do
			set (object, a_value.to_character_8)
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			-- This redefinition is a workaround for a segmentation fault in finalized exe
			if representation = Void then
				set_directly (object, string)

			elseif attached {EL_STRING_FIELD_REPRESENTATION [CHARACTER_8, ANY]} representation as l_representation then
				set (object, l_representation.to_value (string))
			end
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_character_8 (value (object))
		end

feature {NONE} -- Implementation

	append_value (string: STRING_GENERAL; a_value: CHARACTER)
		do
			string.append_code (a_value.natural_32_code)
		end

	append_directly (object: ANY; str: ZSTRING)
		do
			if attached value (object) as v then
				str.append_character_8 (v)
			end
		end

	set_directly (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if string.is_empty then
				set (object, '%U')
			else
				set (object, string.item (1).to_character_8)
			end
		end

	to_string_directly (object: ANY): STRING_8
		do
			create Result.make_filled (value (object), 1)
		end

end